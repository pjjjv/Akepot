
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/competences_service.dart';

@CustomTag("pane-input")
class PaneInput extends PolymerElement {
  PaneInput.created() : super.created();

  @published Project project;
  PaperButton createButton;
  @published String projectHash = "";
  @published var adminRoute;
  @published CompetencesService service;
  @published String newlink;

  void domReady() {
    createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);
  }

  void createProject(Event e){
    print ("createProject");
    projectHash = adminRoute['projectHash'];
    project.categoriesFromJson();
    project.teamsFromJson();
    service.newProject(project, projectHash);
  }
}