
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/competences_service.dart';
import 'dart:async';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_button.dart';

@CustomTag("pane-join")
class PaneJoin extends PolymerElement {
  @observable List<Category> categories = [];
  @published String projectHash = "";
  CompetencesService service;

  PaperButton joinButton;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  PaneJoin.created() : super.created();

  domReady(){
    service = document.querySelector("#service");
    if(categories.isEmpty){//TODO
      startupForProject();
    }
  }

  void copyProject(Event e, var detail, Node target){
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);


  void startupForProject () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForProject);
  }

  void completeStartupForProject () {
    if(service.signedin == false){
      startupForProject();
      return;
    }
    getProject();
  }

  void newUser(Event e, var detail, Node target){
    joinButton = shadowRoot.querySelector("#join-button");
    joinButton.disabled = false;
    joinButton.onClick.first.then(joinProject);
  }

  void joinProject(Event e){
    print ("joinProject");
    service.newPerson("0", projectHash);
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
  }
}