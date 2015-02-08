
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/competences_service.dart';
import 'dart:async';

@CustomTag("pane-input")
class PaneInput extends PolymerElement {
  PaneInput.created() : super.created() {
    startupForAdmin(true);
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
    createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);
  }

  void createProject(Event e){
    print ("createProject");
    project.categoriesFromJson();
    project.teamsFromJson();
    service.newProject(project, projectHash);
  }


  void startupForAdmin (bool first) {
    print(SPLASH_TIMEOUT);
    if(first){
      project = new Project.empty(projectHash);

      HttpRequest.getString("data/fresh_categories.json")
      .then((String text) => project.categoriesAsJson = text)
      .catchError((Error error) => print("Error: $error"));

      HttpRequest.getString("data/fresh_teams.json")
      .then((String text) => project.teamsAsJson = text)
      .catchError((Error error) => print("Error: $error"));
    }
    new Timer(SPLASH_TIMEOUT, completeStartupForAdmin);

  }

  void completeStartupForAdmin () {
    if(service == null || service.signedin == false){
      startupForAdmin(false);
      return;
    }
  }
}