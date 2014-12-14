import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:js';
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_style.dart';
import 'package:template_binding/template_binding.dart';
import 'package:akepot/model/model_category.dart';
import 'package:paper_elements/paper_button.dart';

void main() {
  initPolymer().run(() {
    //(querySelector('#menu_button') as PolymerElement).onClick.listen(openMenu);
    Content contentModel;


    Polymer.onReady.then((_) {
      var content = document.querySelector('#content');
      contentModel = new Content();
      templateBind(content).model = contentModel;

      setAkepotTransitionSpeed(350);

      window.onHashChange.listen((HashChangeEvent e) {
        window.location.href = window.location.href;
        window.location.reload();
      });
    });
  });
}

void openMenu(Event e) {
  print("openMenu");
  var dialog = querySelector('#dialog');
  dialog.toggle();
}

class Content extends Observable {
  //@observable List competences = toObservable([]);
  @observable var projectRoute;
  @observable var adminRoute;

  @observable List<Category> categories = [];

  @observable String selectedSection = "splash";

  String generatedHash = null;
  PaperButton newButton;

  var projectRouter = null;
  var adminRouter = null;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  Content () {
    waitForRouters();
  }

  void waitForRouters (){
    new Timer(new Duration(milliseconds: 100), completeWaitForRouters);
  }

  void completeWaitForRouters () {
    adminRouter = document.querySelector('#adminRoute');
    projectRouter = document.querySelector('#projectRoute');
    if(projectRouter == null || adminRouter == null){
      waitForRouters();
    }
    startup();
  }

  void startup () {
    if(projectRoute != null && projectRoute['projectHash'] != null){
      startupForProject();
    } else if (adminRoute != null && adminRoute['projectHash'] != null){
      startupForAdmin();
    } else {
      startupForHome();
      generatedHash = generateId();
    }
  }
  void startupForProject () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForProject);
  }

  void startupForAdmin () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForAdmin);
  }

  void startupForHome () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForHome);
  }

  void completeStartupForProject () {
    if(categories.isEmpty == true){
      startupForProject();
      return;
    }
    selectedSection = "Technical Competence";//TODO
  }

  void completeStartupForAdmin () {
    /*if(categories.isEmpty == true){
      startupForAdmin();
      return;
    }*/
    selectedSection = "Input";
  }

  void completeStartupForHome () {
    if(generatedHash == null){
      startupForHome();
      return;
    }
    selectedSection = "home-info";
    PaperButton newButton = document.querySelector("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(createProject);
  }

  void goTo(Event e) {
    print("wentTo");
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

  void createProject(Event e){
    String message = context['MoreRouting'].callMethod('urlFor', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
    print("New project link would be: $message");
    context['MoreRouting'].callMethod('navigateTo', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
  }

}

void setAkepotTransitionSpeed(int timeInMs){
  /*CoreStyle.g.transitions.duration = timeInMs + 'ms';
  CoreStyle.g.transitions.scaleDelay = CoreStyle.g.transitions.duration;*/
}
