
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:core_elements/core_ajax_dart.dart';
import 'package:google_signin_dart/google_signin_dart.dart';

@CustomTag('login-screen')
class LoginScreen extends PolymerElement {
  LoginScreen.created() : super.created();
  @observable bool signedin = false;
  @observable String accessToken = "";
  @observable String name = "";

  void signedIn(CustomEvent event, dynamic response){
    signedin = true;

    Map headers = {"Content-type": "application/json",
               "Authorization": "${response['result']['token_type']} ${response['result']['access_token']}"};
    CoreAjax peopleAjax =shadowRoot.querySelector('#ajax-people');
    peopleAjax.headers = headers;
    peopleAjax.go();
  }

  void signedOut(CustomEvent event, dynamic detail){
    print("google-signin-aware-signed-out $detail");
    signedin = false;
  }

  void signOut(){
    GoogleSignin button = shadowRoot.querySelector("google-signin");
    button.signOut();
  }

  void parseResponse2(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //print(response);

    try {
      if (response == null) {
        //print('returned');
        return null;
      }
    } catch (e) {
      //print('returned');
      return null;
    }

    if(response['nickname'] != null){
      name = ", "+response['nickname'];
    } else {
      name = ", "+response['displayName'];
    }
    //String email = response['emails'][0]['value'];
    //userid = response['id'];
  }

  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
  }
}
