import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/model/model_project.dart';
import 'package:app_router/app_router.dart';
//import 'package:akepot/competences_service.dart';
import 'dart:js';
import 'dart:async';
import 'dart:typed_data';

@CustomTag("pane-home")
class PaneHome extends PolymerElement {
  PaneHome.created() : super.created();

  PaperButton newButton;
  Project project;
  String generatedHash = null;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void domReady(){
    newButton = shadowRoot.querySelector("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(newProject);
    startupForHome();
    generatedHash = generateId();
  }

  void newProject(Event e){
    //String message = window.history.toString();
    //RouteUri url = new RouteUri.parse(window.location.href);

    (document.querySelector('app-router') as AppRouter).go("/admin/$generatedHash/input");
    //String message = context['MoreRouting'].callMethod('urlFor', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
    //print("New admin link would be: $message");
    //context['MoreRouting'].callMethod('navigateTo', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
  }

  void startupForHome () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForHome);
  }

  void completeStartupForHome () {
    if(generatedHash == null){
      startupForHome();
      return;
    }
  }

  // String generateId(int length);
  //   length - must be an even number (default: 20)
  String generateId([int length = 20]) {
    Uint8List array = new Uint8List((length / 2).round());
    window.crypto.getRandomValues(array);
    String result = array.map((n) => n.toRadixString(16)).join("");
    print("generateId: $result");
    return result;
  }
}