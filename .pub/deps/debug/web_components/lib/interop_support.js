// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Updates document.registerElement so Dart can see when Javascript custom
// elements are created, and wrap them to provide a Dart friendly API.
(function (doc) {
  if (window._dart_register_element_interop_support) return;
  window._dart_register_element_interop_support = true;

  var upgraders = {};       // upgrader associated with a custom-tag.
  var unpatchableTags = {}; // set of custom-tags that can't be patched.
  var pendingElements = {}; // will upgrade when/if an upgrader is installed.
  var upgradeOldElements = true;

  var originalRegisterElement = doc.registerElement;
  if (!originalRegisterElement) {
    throw new Error('document.registerElement is not present.');
  }

  function reportError(name) {
    console.error("Couldn't patch prototype to notify Dart when " + name +
        " elements are created. This can be fixed by making the " +
        "createdCallback in " + name + " a configurable property.");
  }

  function registerElement(name, options) {
    var proto, extendsOption;
    if (options !== undefined) {
      proto = options.prototype;
    } else {
      proto = Object.create(HTMLElement.prototype);
      options = {protoptype: proto};
    }

    var original = proto.createdCallback;
    var newCallback = function() {
      original.call(this);
      var name = (this.getAttribute('is') || this.localName).toLowerCase();
      var upgrader = upgraders[name];
      if (upgrader) {
        upgrader(this);
      } else if (upgradeOldElements) {
        // Save this element in case we can upgrade it later when an upgrader is
        // registered.
        var list = pendingElements[name];
        if (!list) {
          list = pendingElements[name] = [];
        }
        list.push(this);
      }
    };

    var descriptor = Object.getOwnPropertyDescriptor(proto, 'createdCallback');
    if (!descriptor || descriptor.writable) {
      proto.createdCallback = newCallback;
    } else if (descriptor.configurable) {
      descriptor['value'] = newCallback;
      Object.defineProperty(proto, 'createdCallback', descriptor);
    } else {
      unpatchableTags[name] = true;
      if (upgraders[name]) reportError(name);
    }
    return originalRegisterElement.call(this, name, options);
  }

  function registerDartTypeUpgrader(name, upgrader) {
    if (!upgrader) return;
    name = name.toLowerCase();
    var existing = upgraders[name];
    if (existing) {
      console.error('Already have a Dart type associated with ' + name);
      return;
    }
    upgraders[name] = upgrader;
    if (unpatchableTags[name]) reportError(name);
    if (upgradeOldElements) {
      // Upgrade elements that were created before the upgrader was registered.
      var list = pendingElements[name];
      if (list) {
        for (var i = 0; i < list.length; i++) {
          upgrader(list[i]);
        }
      }
      delete pendingElements[name];
    } else {
      console.warn("Didn't expect more Dart types to be registered. '" + name
          + "' elements that already exist in the page might not be wrapped.");
    }
  }

  function onlyUpgradeNewElements() {
    upgradeOldElements = false;
    pendingElements = null;
  }

  // Native custom elements outside the app in Chrome have constructor
  // names like "x-tag", which need to be translated to the DOM
  // element they extend.  When using the shadow dom polyfill this is
  // taken care of in dart_support.js.
  var ShadowDOMPolyfill = window.ShadowDOMPolyfill;
  if (!ShadowDOMPolyfill) {
    // dartNativeDispatchHooksTransformer is described on initHooks() in
    // sdk/lib/_internal/lib/native_helper.dart.
    if (typeof window.dartNativeDispatchHooksTransformer == 'undefined')
    window.dartNativeDispatchHooksTransformer = [];

    window.dartNativeDispatchHooksTransformer.push(function(hooks) {
      var originalGetUnknownTag = hooks.getUnknownTag;
      hooks.getUnknownTag = function(o, tag) {
        if (/-/.test(tag)) {  // "x-tag"
          var s = Object.prototype.toString.call(o);
          var match = s.match(/^\[object ([A-Za-z]*Element)\]$/);
          if (match) {
            return match[1];
          }
          return originalGetUnknownTag(o, tag);
        }
      };
    });
  }

  doc._registerDartTypeUpgrader = registerDartTypeUpgrader;
  doc._onlyUpgradeNewElements = onlyUpgradeNewElements;
  doc.registerElement = registerElement;
})(document);
