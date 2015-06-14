
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created() {
    project = new Project.empty(projectHash);

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @observable Project project;
  PaperButton createButton;

  CompetencesService service;
  @published String projectHash = "";
  @observable String newlink;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void domReady() {
    service = document.querySelector("#service");
    /*createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);*/
  }

  void createProject(Event e){
    print ("createProject");
    project.categoriesFromJson();
    project.teamsFromJson();
    service.newProject(project, projectHash);
  }

  void showDialog(Event e, var detail, Node target){
    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/" + projectHash;
    print("New project link would be: $newlink");

    PaperActionDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }
}