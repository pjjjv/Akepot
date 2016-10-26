@HtmlImport('login_google.html')
library akepot.lib.login.login_google;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html' as html;
import 'package:akepot/competences_service.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/paper_ripple.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/iron_iconset_svg.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'package:firebase3/firebase.dart' as firebase;

@PolymerRegister("login-google")
class LoginGoogle extends PolymerElement {
  LoginGoogle.created() : super.created();

  /**
   * Enum height values.
   * @readonly
   * @enum {string}
   */
  static const String HEIGHT_SHORT = 'short';
  static const String HEIGHT_STANDARD = 'standard';
  static const String HEIGHT_TALL = 'tall';

  /**
   * Enum button label default values.
   * @readonly
   * @enum {string}
   */
  static const String LABEL_STANDARD = 'Sign in';
  static const String LABEL_WIDE = 'Sign in with Google';

  /**
   * Enum theme values.
   * @readonly
   * @enum {string}
   */
  static const String THEME_LIGHT = 'light';
  static const String THEME_DARK = 'dark';

  /**
   * Enum width values.
   * @readonly
   * @enum {string}
   */
  static const String WIDTH_ICON_ONLY = 'iconOnly';
  static const String WIDTH_STANDARD = 'standard';
  static const String WIDTH_WIDE = 'wide';

  @property bool raised = false;
  @Property(reflectToAttribute: true) String height = HEIGHT_STANDARD;
  @Property(reflectToAttribute: true) String width = WIDTH_STANDARD;
  @property String theme = THEME_DARK;
  @property bool signedIn = false;
  @property String labelSignin = '';
  @property String labelSignout = 'Sign out';
  @Property(reflectToAttribute: true) String clientId = '';
  @property String brand = 'google';
  @property bool fill = true;
  @Property(reflectToAttribute: true) String scopes = '';

  ready(){
    if (clientId == '' || clientId == null) {
      throw 'A valid clientId is required to use this element';
    }

    // If no label supplied use the width to determine label.
    if (labelSignin == null || labelSignin == '') {
      if (width == WIDTH_WIDE) {
        set('labelSignin', LABEL_WIDE);
      } else if (width == WIDTH_STANDARD) {
        set('labelSignin', LABEL_STANDARD);
      }
    }
  }

  @reflectable
  void signIn(html.Event e, var detail){
    firebase.GoogleAuthProvider provider = new firebase.GoogleAuthProvider();
    /*provider.addScope('https://www.googleapis.com/auth/plus.login');
    provider.addScope('https://www.googleapis.com/auth/plus.me');
    provider.addScope('https://www.googleapis.com/auth/userinfo.email');
    provider.addScope('https://www.googleapis.com/auth/userinfo.profile');*/
    firebase.auth().signInWithPopup(provider).then((authData) {
      if (DEBUG) print("Authenticated successfully with payload:" + authData.toString());

      // Trigger the loginsuccess event
      this.fire( "iron-signal", detail: { "name": "loginsuccess", "data": authData } );

      set('signedIn', true);
    },
    onError:(error) {
      if (DEBUG) print("Login Failed!" + error.toString());

      if (error == "user_signed_out") {
        // Fire event to indicate user signed out
        this.fire( "iron-signal", detail: { "name": "loginsignedout", "data": error } );
      } else {
        // Fire event to indicate sign-in was not successful
        this.fire( "iron-signal", detail: { "name": "loginsigninfailure", "data": error } );
      }

      // No access token could be retrieved, show the button to start the authorization flow.
      set('signedIn', false);
    });
  }

  @reflectable
  void signInKeyPress(CustomEventWrapper ew, var detail){
    html.KeyboardEvent e = ew.original;
    if (e.which == 13 || e.keyCode == 13 || e.which == 32 || e.keyCode == 32) {
      e.preventDefault();
      signIn(e, detail);
    }
  }

  @reflectable
  void signOut(html.Event e, var detail){
    if (DEBUG) print("Sign out");
    this.fire( "iron-signal", detail: { "name": "loginsignoutattempted" } );
    firebase.auth().signOut();
    this.fire( "iron-signal", detail: { "name": "loginsignedout" } );
    set('signedIn', false);
  }

  @reflectable
  void signOutKeyPress(CustomEventWrapper ew, var detail){
    html.KeyboardEvent e = ew.original;
    if (e.which == 13 || e.keyCode == 13 || e.which == 32 || e.keyCode == 32) {
      e.preventDefault();
      signOut(e, detail);
    }
  }

  @reflectable
  String computeClass(String height, bool signedIn, String theme, String width) {
    return "height-$height width-$width theme-$theme signedIn-$signedIn";
  }
}
