@HtmlImport('login_screen.html')
library akepot.lib.login_screen;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/login/login_google.dart';

@PolymerRegister('login-screen')
class LoginScreen extends PolymerElement {
  LoginScreen.created() : super.created();
  @property bool signedIn = false;
  String accessToken = "";
  String name = "";

  @reflectable
  void signInDone(Event e, var response){
    signedIn = true;

    Map headers = {"Content-type": "application/json",
               "Authorization": "Bearer ${response['credential']['accessToken']}"};
    IronAjax peopleAjax =$$('#ajax-people');
    peopleAjax.headers = headers;
    peopleAjax.generateRequest();
  }

  @reflectable
  void signOutDone(Event e, var detail){
    if (DEBUG) print("loginsignedout" + detail.toString());
    signedIn = false;
  }

  @reflectable
  void signOut(Event e, var detail){
    LoginGoogle button = $$("login-google");
    button.signOut(e, detail);
  }

  @reflectable
  void parseResponse2(Event e, var response) {
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

    /*if(response['nickname'] != null){
      name = ", "+response['nickname'];
    } else {
      name = ", "+response['displayName'];
    }*/
    //String email = response['emails'][0]['value'];
    //userid = response['id'];
  }

  @reflectable
  void ajaxError(Event e, var detail) {
    if (DEBUG) print(detail);
  }
}
