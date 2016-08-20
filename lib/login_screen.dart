@HtmlImport('login_screen.html')
library akepot.lib.login_screen;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:polymer_elements/iron_ajax.dart';
import 'login/login_google.dart';
import 'package:akepot/competences_service.dart';

@PolymerRegister('login-screen')
class LoginScreen extends PolymerElement {
  LoginScreen.created() : super.created();
  bool signedIn = false;
  String accessToken = "";
  String name = "";

  void signInDone(CustomEvent event, dynamic response){
    signedIn = true;

    Map headers = {"Content-type": "application/json",
               "Authorization": "Bearer ${response['google']['accessToken']}"};
    IronAjax peopleAjax =shadowRoot.querySelector('#ajax-people');
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
