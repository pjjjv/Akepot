
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:core_elements/core_ajax_dart.dart';
import 'login/login_google.dart';
import 'package:akepot/competences_service.dart';

@CustomTag('login-screen')
class LoginScreen extends PolymerElement {
  LoginScreen.created() : super.created();
  @observable bool signedIn = false;
  @observable String accessToken = "";
  @observable String name = "";

  void signInDone(CustomEvent event, dynamic response){
    signedIn = true;

    Map headers = {"Content-type": "application/json",
               "Authorization": "Bearer ${response['google']['accessToken']}"};
    CoreAjax peopleAjax =shadowRoot.querySelector('#ajax-people');
    peopleAjax.headers = headers;
    peopleAjax.go();
  }

  void signOutDone(CustomEvent event, dynamic detail){
    if (DEBUG) print("loginsignedout" + detail.toString());
    signedIn = false;
  }

  void signOut(Event event){
    LoginGoogle button = shadowRoot.querySelector("login-google");
    button.signOut(event);
  }

  void parseResponse2(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //if (DEBUG) print(response);

    try {
      if (response == null) {
        //if (DEBUG) print('returned');
        return null;
      }
    } catch (e) {
      //if (DEBUG) print('returned');
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
    if (DEBUG) print(detail);
  }
}
