@HtmlImport('login_google.html')
library akepot.lib.login.login_google;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html' as html;
import 'package:akepot/competences_service.dart';

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
  @property String height = HEIGHT_STANDARD;
  @property String width = WIDTH_STANDARD;
  @property String theme = THEME_DARK;
  @property bool signedIn = false;
  @property String labelSignin = '';
  @property String labelSignout = 'Sign out';
  @property String clientId = '';
  @property String brand = 'google';
  @property bool fill = true;
  @property String scopes = '';

  CompetencesService service;

  domReady(){
    service = html.document.querySelector("#service");

    if (clientId == '' || clientId == null) {
      throw 'A valid clientId is required to use this element';
    }

    // If no label supplied use the width to determine label.
    if (labelSignin == null || labelSignin == '') {
      if (width == WIDTH_WIDE) {
        labelSignin = LABEL_WIDE;
      } else if (width == WIDTH_STANDARD) {
        labelSignin = LABEL_STANDARD;
      }
    }
  }

  void signIn(html.Event e){
    service.dbRef.authWithOAuthPopup("google", remember: "default", scope: scopes).then((authData) {
      if (DEBUG) print("Authenticated successfully with payload:" + authData.toString());

      // Trigger the loginsuccess event
      this.fire( "iron-signal", detail: { "name": "loginsuccess", "data": authData } );

      signedIn = true;
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
      signedIn = false;
    });
  }

  void signInKeyPress(html.KeyboardEvent e){
    if (e.which == 13 || e.keyCode == 13 || e.which == 32 || e.keyCode == 32) {
      e.preventDefault();
      signIn(e);
    }
  }

  void signOut(html.Event e){
    if (DEBUG) print("Sign out");
    this.fire( "iron-signal", detail: { "name": "loginsignoutattempted" } );
    service.dbRef.unauth();
    this.fire( "iron-signal", detail: { "name": "loginsignedout" } );
    signedIn = false;
  }

  void signOutKeyPress(html.KeyboardEvent e){
    if (e.which == 13 || e.keyCode == 13 || e.which == 32 || e.keyCode == 32) {
      e.preventDefault();
      signOut(e);
    }
  }
}