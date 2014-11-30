//Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
//This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
//The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
//The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
//Code distributed by Google as part of the polymer project is also
//subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt

//<polymer-element name="core-ajax" attributes="url handleAs auto params response method headers body contentType withCredentials">

library core_ajax_dart2;

import 'dart:convert' show JSON;
import 'dart:async';
import 'dart:html';

import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:quiver/core.dart';
import 'package:quiver/strings.dart';

import 'core_xhr_dart2.dart';

@CustomTag('core-ajax-dart2')
class CoreAjax extends PolymerElement {

  static const _onCoreResponse = const EventStreamProvider('core-response');
  static const _onCoreComplete = const EventStreamProvider('core-complete');
  static const _onCoreError = const EventStreamProvider('core-error');

  GoogleOAuth2 auth;

  CoreXhr xhr;
  PolymerJob _goJob;
// TODO: enable xhrArgs
//  var xhrArgs;

  CoreAjax.created() : super.created() {
    logger.fine('CoreAjax.created');
    this.xhr = document.createElement('core-xhr-dart2');
  }

  /**
   * Fired when a response is received.
   */
  Stream<CustomEvent> get onCoreResponse => _onCoreResponse.forElement(this);

  /**
   * Fired when an error is received.
   */
  Stream<CustomEvent> get onCoreComplete => _onCoreComplete.forElement(this);

  /**
   * Fired whenever a response or an error is received.
   */
  Stream<CustomEvent> get onCoreError => _onCoreError.forElement(this);

  final Logger logger = new Logger('core_ajax_dart2');

  /**
   * The URL target of the request.
   */
  @published
  String url = '';

  /**
   * Specifies what data to store in the `response` property, and
   * to deliver as `event.response` in `response` events.
   *
   * One of:
   *
   *    `text`: uses `XHR.responseText`.
   *
   *    `xml`: uses `XHR.responseXML`.
   *
   *    `json`: uses `XHR.responseText` parsed as JSON.
   *
   *    `arraybuffer`: uses `XHR.response`.
   *
   *    `blob`: uses `XHR.response`.
   *
   *    `document`: uses `XHR.response`.
   */
  @published
  String handleAs = 'text';

  /**
   * If true, automatically performs an Ajax request when either `url` or `params` changes.
   */
  @published
  bool auto = false;

  /**
   * Parameters to send to the specified URL, as JSON.
   */
  @published
  String params = '';

  /**
   * The response for the most recently made request, or null if it hasn't
   * completed yet or the request resulted in error.
   */
  @published
  var response;

  /**
   * The error for the most recently made request, or null if it hasn't
   * completed yet or the request resulted in success.
   */
  @published
  var error;

  /**
   * The HTTP method to use such as 'GET', 'POST', 'PUT', or 'DELETE'.
   * Default is 'GET'.
   */
  @published
  String method = '';

  /**
   * HTTP request headers to send.
   *
   * Example:
   *
   *     <core-ajax
   *         auto
   *         url="http://somesite.com"
   *         headers='{"X-Requested-With": "XMLHttpRequest"}'
   *         handleAs="json"
   *         on-core-response="{{handleResponse}}"></core-ajax>
   */
  @published
  Map headers = null;

  /**
   * Optional raw body content to send when method === "POST".
   *
   * Example:
   *
   *     <core-ajax method="POST" auto url="http://somesite.com"
   *         body='{"foo":1, "bar":2}'>
   *     </core-ajax>
   */
  String body;

  /**
   * Content type to use when sending data.
   *
   * @default 'application/x-www-form-urlencoded'
   */
  String contentType = 'application/x-www-form-urlencoded';

  /**
   * Set the withCredentials flag on the request.
   *
   * @attribute withCredentials
   * @type boolean
   * @default false
   */
  bool withCredentials = false;

  /**
   * The currently active request.
   */
  HttpRequest activeRequest;

  void receive(response, HttpRequest xhr) {
    logger.fine('receive');
    if (this.isSuccess(xhr)) {
      this.processResponse(xhr);
    } else {
      this.processError(xhr);
    }
    this.complete(xhr);
  }

  bool isSuccess(HttpRequest xhr) {
    var status = xhr.status;
    return (status == null || status == 0) || (status >= 200 && status < 300);
  }

  void processResponse(xhr) {
    var response = this.evalResponse(xhr);
    if (xhr == this.activeRequest) {
      this.response = response;
    }
    this.fire('core-response', detail: {'response': response, 'xhr': xhr});
  }


  void processError(xhr) {
    var response = '${xhr.status}: ${xhr.responseText}';
    if (xhr == this.activeRequest) {
      this.error = response;
    }
    this.fire('core-error', detail: {'response': response, 'xhr': xhr});
  }

  complete(xhr) {
    this.fire('core-complete', detail: {'response': xhr.status, 'xhr': xhr});
  }

  evalResponse(xhr) {
    switch (handleAs) {
      case 'xml':
        return xmlHandler(xhr);
      case 'json':
        return jsonHandler(xhr);
      case 'document':
        return documentHandler(xhr);
      case 'blob':
        return blobHandler(xhr);
      case 'arraybuffer':
        return arraybufferHandler(xhr);
      default:
        return textHandler(xhr);
    }
  }

  xmlHandler(HttpRequest xhr) {
    return xhr.responseXml;
  }

  textHandler(HttpRequest xhr) {
    return xhr.responseText;
  }

  dynamic jsonHandler(HttpRequest xhr) {
    var r = xhr.responseText;
    try {
      return JSON.decode(r);
    } catch (x) {
      logger.severe(
          'core-ajax caught an exception trying to parse response as JSON:');
      logger.severe('url: $url');
      logger.severe(x);
      return r;
    }
  }

  documentHandler(HttpRequest xhr) {
    return xhr.response;
  }

  blobHandler(HttpRequest xhr) {
    return xhr.response;
  }

  arraybufferHandler(HttpRequest xhr) {
    return xhr.response;
  }

  urlChanged() {
    if (!isBlank(this.handleAs)) {
      var ext = this.url.split('.').last;
      switch (ext) {
        case 'json':
          this.handleAs = 'json';
          break;
      }
    }
    this.autoGo();
  }

  paramsChanged() {
    this.autoGo();
  }

  autoChanged() {
    this.autoGo();
  }

  // TODO(sorvell): multiple side-effects could call autoGo
  // during one micro-task, use a job to have only one action
  // occur
  autoGo() {
    if (this.auto) {
      this._goJob = this.scheduleJob(this._goJob, this.go, new Duration());
    }
  }

  /**
   * Performs an Ajax request to the specified URL.
   *
   * @method go
   */
  go() {
    // TODO(justinfagnani): support xhrArgs configuration
/*
    Map args = firstNonNull(xhrArgs, {});
     //TODO(sjmiles): we may want XHR to default to POST if body is set
    var body = firstNonNull(this.body, args.body);
    var params = firstNonNull(this.params, args.params);
    if (args.params is String) {
      args.params = JSON.decode(args.params);
    }
    var headers = firstNonNull(this.headers, args.headers, {});
*/
    auth = new GoogleOAuth2(
        "71435708886-adrd3d3qumqm1ssedko964621rlku3nj.apps.googleusercontent.com",
        ["https://www.googleapis.com/auth/userinfo.email"],
        tokenLoaded: authenticated,
        autoLogin: false);
    auth.login();

    var params = this.params.isEmpty ? {} : JSON.decode(this.params);
    var headers = firstNonNull(this.headers, {});
    if (headers is String) {
      headers = JSON.decode(headers);
    }
    var hasContentType = headers.keys.any((header) {
      return header.toLowerCase() == 'content-type';
    });
    if (!hasContentType && this.contentType != null
        && !this.contentType.isEmpty) {
      headers['Content-Type'] = this.contentType;
    }
    var responseType;
    if (this.handleAs == 'arraybuffer' || this.handleAs == 'blob' ||
        this.handleAs == 'document') {
      responseType = this.handleAs;
    }
    this.response = this.error = null;
    this.activeRequest = url == null ? null : this.xhr.request(
        url: url,
        method: method,
        headers: headers,
        body: body,
        params: params,
        withCredentials: withCredentials,
        responseType: responseType,
        callback: this.receive
    );
    return this.activeRequest;
  }

}
