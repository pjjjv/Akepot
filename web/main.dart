import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:js';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_style.dart';
import 'package:template_binding/template_binding.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_project.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_autogrow_textarea.dart';
import 'package:akepot/competences_service.dart';

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

  @observable String projectHash = "";
  @observable String userId = "";
  @observable String newlink;
  @observable bool newuser;
  @observable bool signedin;

  String generatedHash = null;
  PaperButton newButton;
  PaperButton createButton;
  PaperButton joinButton;

  var projectRouter = null;
  var adminRouter = null;

  CompetencesService service;

  @observable Project project;

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
    service = document.querySelector('#service');
    startup();
  }

  void startup () {
    if(projectRoute != null && projectRoute['projectHash'] != null){
      startupForProject();
    } else if (adminRoute != null && adminRoute['projectHash'] != null){
      startupForAdmin(true);
    } else {
      startupForHome();
      generatedHash = generateId();
    }
  }
  void startupForProject () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForProject);
  }

  void startupForAdmin (bool first) {
    print(SPLASH_TIMEOUT);
    if(first){
      project = new Project.empty(adminRoute['projectHash']);

      HttpRequest.getString("data/fresh_categories.json")
      .then((String text) => project.categoriesAsJson = text)
      .catchError((Error error) => print("Error: $error"));

      HttpRequest.getString("data/fresh_teams.json")
      .then((String text) => project.teamsAsJson = text)
      .catchError((Error error) => print("Error: $error"));

      projectHash = adminRoute['projectHash'];
    }
    new Timer(SPLASH_TIMEOUT, completeStartupForAdmin);

  }

  void startupForHome () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForHome);
  }

  void completeStartupForProject () {
    if(signedin == false){
      startupForProject();
      return;
    }
    startGetProject(true);
  }
  void startGetProject (bool first) {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeGetProject);
    if (first) {
      projectHash = projectRoute['projectHash'];
      getProject();
    }
  }

  void completeGetProject () {
    if(categories.isEmpty == true && newuser == false){
      startGetProject(false);
      return;
    }
    if(categories.isEmpty == false){
      selectedSection = categories.first.name;
    }
    if(newuser == true){
      selectedSection = "join";
      newuser = false;
      joinButton = document.querySelector("#join-button");
      joinButton.onClick.listen(joinProject);
    }
  }

  void completeStartupForAdmin () {
    if(signedin == false){
      startupForAdmin(false);
      return;
    }
    selectedSection = "input";
    createButton = document.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);
  }

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
  }

  void createProject(Event e){
    print ("createProject");
    projectHash = adminRoute['projectHash'];
    project.categoriesFromJson();
    project.teamsFromJson();
    service.newProject(project, projectHash);
  }

  void joinProject(Event e){
    print ("joinProject");
    service.newPerson("0", projectHash);
    startGetProject(false);
  }

  void completeStartupForHome () {
    if(generatedHash == null){
      startupForHome();
      return;
    }
    projectHash = generatedHash;
    selectedSection = "home";
    newButton = document.querySelector("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(newProject);
  }

  void goTo(Event e) {
    print("wentTo");
  }

  void goTo2(Event e) {
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

  void newProject(Event e){
    String message = context['MoreRouting'].callMethod('urlFor', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
    print("New admin link would be: $message");
    context['MoreRouting'].callMethod('navigateTo', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
  }

}

void setAkepotTransitionSpeed(int timeInMs){
  /*CoreStyle.g.transitions.duration = timeInMs + 'ms';
  CoreStyle.g.transitions.scaleDelay = CoreStyle.g.transitions.duration;*/
}