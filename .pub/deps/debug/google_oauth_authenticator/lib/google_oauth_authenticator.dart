import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";

/// The `google-oauth-authenticator` element provides an authentication service
/// in Dart for Polymer apps that wish to use OAuth 2.0 for Google services or signin.
@CustomTag('google-oauth-authenticator')
class GoogleOAuthAuthenticator extends PolymerElement with ChangeNotifier  {
/// The `authenticated` event is fired when the authenticator has received
/// confirmation from the api and has tokens to be used and fired again
/// every token refresh.
///
/// @event authenticated

/// The [clientId] attribute stores the client id for the given project.
/// @attribute clientId
/// @type String
  @reflectable @published String get clientId => __$clientId; String __$clientId; @reflectable set clientId(String value) { __$clientId = notifyPropertyChange(#clientId, __$clientId, value); }

/// The [scopes] attribute is a space delimited list of the request OAuth scopes.
/// @attribute scopes
/// @type List<String>
  @reflectable @published List<String> get scopes => __$scopes; List<String> __$scopes; @reflectable set scopes(List<String> value) { __$scopes = notifyPropertyChange(#scopes, __$scopes, value); }

/// The [auto] attribute makes the authentication happen automatically when loaded.
/// @attribute auto
/// @type bool
  @reflectable @published bool get auto => __$auto; bool __$auto = true; @reflectable set auto(bool value) { __$auto = notifyPropertyChange(#auto, __$auto, value); }

/// The [forcePrompt] attribute forces a credential prompt to be shown.
/// @attribute forcePrompt
/// @type bool
  @reflectable @published bool get forcePrompt => __$forcePrompt; bool __$forcePrompt = false; @reflectable set forcePrompt(bool value) { __$forcePrompt = notifyPropertyChange(#forcePrompt, __$forcePrompt, value); }

/// The [forceLoadToken] attribute forces to load the cached token.
/// @attribute forceLoadToken
/// @type bool
  @reflectable @published bool get forceLoadToken => __$forceLoadToken; bool __$forceLoadToken = false; @reflectable set forceLoadToken(bool value) { __$forceLoadToken = notifyPropertyChange(#forceLoadToken, __$forceLoadToken, value); }

  GoogleOAuth2 _auth;

  GoogleOAuthAuthenticator.created() : super.created() {
    if(auto){
      authorize(false, tokenLoaded, tokenNotLoaded);
    }
  }

/// The [authorize] method sends an authorization request to OAuth
///
/// @method authorize
/// @param {Boolean} prompt Defines wether or not the request should be made in immediate mode (i.e, prompt pop-up)
/// @param {Function} tokenLoadedCallback Defines a callback function to be executed that processes the valid token output.
/// @param {Function} tokenNotLoadedCallback Defines a callback function to be executed that processes when a token could not be produced.
  void authorize(bool prompt, tokenLoadedCallback, tokenNotLoadedCallback){
    if (_auth != null){
      _auth.login(immediate: !prompt, onlyLoadToken: forceLoadToken)
      .whenComplete(tokenLoadedCallback)
      .catchError(tokenNotLoadedCallback);
    } else {
      _auth = new GoogleOAuth2(
          clientId,
          scopes,
          tokenLoaded: tokenLoadedCallback,
          tokenNotLoaded: tokenNotLoadedCallback,
          autoLogin: !prompt && !forcePrompt,
          approval_prompt: forcePrompt?'force':'auto',
          autoLoadStoredToken: forceLoadToken);
    }
  }

/// The [tokenLoaded] method handles a token.
///
/// @method tokenLoaded
/// @param {Token} token Defines the return object from the oauth server.
  void tokenLoaded(Token token){
    dispatchEvent(new CustomEvent('authenticated', detail: token));
    Duration duration = token.expiry.difference(new DateTime.now());
    Timer timer = new Timer(duration, refresh);
  }

/// The [tokenNotLoaded] method handles the failure getting a token.
///
/// @method tokenNotLoaded
  tokenNotLoaded(){
    authorize(true, tokenLoaded, tokenNotLoaded);
  }

/// The [refresh] method handles the refresh of tokens.
///
/// @method refresh
  void refresh(){
    authorize(false, tokenLoaded, tokenNotLoaded);
  }

  _redo(){
    if(_auth!=null){
      _auth = null;
      authorize(false, tokenLoaded, tokenNotLoaded);
    }
  }

  autoChanged() {
    if(auto){
      authorize(false, tokenLoaded, tokenNotLoaded);
    }
  }

  clientIdChanged(){
    _redo();
  }

  scopesChanged(){
    _redo();
  }

  forcePromptChanged(){
    _redo();
  }

  forceLoadTokenChanged(){
    _redo();
  }
}