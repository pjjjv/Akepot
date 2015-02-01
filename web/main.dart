import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:js';
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_style.dart';
import 'package:template_binding/template_binding.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_project.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_autogrow_textarea.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/login_screen.dart';

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

      new AppCache(window.applicationCache);
    });
  });
}

class Content extends Observable {
  //@observable List competences = toObservable([]);
  @observable var projectRoute;
  @observable var adminRoute;

  @observable List<Category> categories = [];

  @observable String selectedSection = "splash";

  @observable String projectHash = "";
  @observable bool newuser;
  @observable bool signedin;
  @observable User user;

  @observable String generatedHash = null;
  PaperButton joinButton;

  var projectRouter = null;
  var adminRouter = null;

  @observable CompetencesService service;

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
  }

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
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
  }

  void signOut(Event e) {
    (document.querySelector("#loginscreen") as LoginScreen).signOut();
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

  void about(Event e) {
    var dialog = querySelector('#about-dialog');
    dialog.toggle();
  }

}

void setAkepotTransitionSpeed(int timeInMs){
  /*CoreStyle.g.transitions.duration = timeInMs + 'ms';
  CoreStyle.g.transitions.scaleDelay = CoreStyle.g.transitions.duration;*/
}

class AppCache {
  ApplicationCache appCache;

  AppCache(this.appCache) {
    // Set up handlers to log all of the cache events or errors.
    appCache.onCached.listen(onCachedEvent);
    appCache.onError.listen(onCacheError);

    // Set up a more interesting handler to swap in the new app when ready.
    appCache.onUpdateReady.listen((e) => updateReady());
  }

  void updateReady() {
    if (appCache.status == ApplicationCache.UPDATEREADY) {
      // The browser downloaded a new app cache. Alert the user and swap it in
      // to get the new hotness.
      appCache.swapCache();

      if (window.confirm('A new version of this site is available. Reload?')) {
        window.location.reload();
      }
    }
  }

  void onCachedEvent(Event e) {
    window.alert("Finished downloading into cache. This web app can now be used offline.");
    print('Cache event: ${e}');
  }

  void onCacheError(Event e) {
    // For the sake of this sample alert the reader that an error has occurred.
    // Of course we would *never* do it this way in real life.
    window.alert("Oh no! A cache error occurred: ${e}");
    print('Cache error: ${e}');
  }
}
