import 'dart:html';
import 'package:polymer/polymer.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";

@CustomTag('google-oauth-authenticator')
class GoogleOAuthAuthenticator extends PolymerElement {
  /**
   * The `authenticated` event is fired when the authenticator has received
   * confirmation from the api and has tokens to be used and fired again
   * every token refresh
   *
   * @event authenticated
   */

  /**
   * The `client_id` attribute stores the client id for the given project
   *
   * @attribute client_id
   * @type string
   */
  @published String client_id;

  /**
   * The `scopes` attribute is a space delimited list of the request OAuth
   * scopes
   *
   * @attribute scopes
   * @type string
   */
  @published String scopes;

  @published bool auto = true;

  GoogleOAuth2 auth;



  GoogleOAuthAuthenticator.created() : super.created() {
    if(auto){
      authorize(false, tokenLoaded, tokenNotLoaded);
    }
  }

  /**
   * The `authorize` method sends an authorization request to OAuth
   *
   * @method authorize
   * @param {Boolean} prompt Defines wether or not the request should be made in immediate mode (i.e, prompt pop-up)
   * @param {Function} verify Defines a callback function to be executed that verifies the output.
   */
  void authorize(prompt, tokenLoadedCallback, tokenNotLoadedCallback){
    auth = new GoogleOAuth2(
        client_id,
        [scopes],//TODO
        tokenLoaded: tokenLoadedCallback,
        tokenNotLoaded: tokenNotLoadedCallback,
        autoLogin: !prompt);
    auth.login();
  }
  /**
   * The `verify` method handles an authResult and checks for any errors
   * before either accepting or reattempting.
   *
   * @method verify
   * @param {Object} authResult Defines a return object from gapi.auth
   */
  void tokenLoaded(Token token){
    dispatchEvent(new CustomEvent('authenticated', detail: {'token': token.data}));
    //window.setTimeout(refresh, authResult.expires_in * 1000);
  }
  void tokenNotLoaded(){
    authorize(true, tokenLoaded, tokenNotLoaded);
  }


  /**
   * The `refresh` method handles the refresh of tokens
   *
   * @method refresh
   */
  void refresh(){
    authorize(false, tokenLoaded, tokenNotLoaded);
  }

}