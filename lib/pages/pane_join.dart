
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';
import 'dart:async';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_button.dart';

@CustomTag("pane-join")
class PaneJoin extends PolymerElement {
  @published String projectHash = "";
  CompetencesService service;

  PaperButton joinButton;

  PaneJoin.created() : super.created();

  domReady(){
    service = document.querySelector("#service");

    Project project = new Project.retrieve(projectHash, service);
    if (project != null){
      (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
    }
  }

  void newUser(Event e, var detail, Node target){
    joinButton = shadowRoot.querySelector("#join-button");
    joinButton.disabled = false;
    joinButton.onClick.first.then(joinProject);
  }

  void joinProject(Event e){
    print ("joinProject");

    service.newPerson("0", projectHash, service.ajaxNewPersonResponse);
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }
}