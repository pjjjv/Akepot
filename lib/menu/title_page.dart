import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';

@CustomTag('title-page')
class TitlePage extends PolymerElement {
  TitlePage.created() : super.created();

  @observable CompetencesService service;
  @published String projectHash = "";
  @observable String projectName = "";

  void domReady(){
    service = document.querySelector("#service");
    projectName = projectHash;
    Project.getName(projectHash, service, (projectName) {
      this.projectName = projectName;
    });
  }
}