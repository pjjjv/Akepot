import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';

@CustomTag('title-page')
class TitlePage extends PolymerElement {
  TitlePage.created() : super.created();

  @observable CompetencesService service;
  @published String projectHash = "";
  @observable String name = "";

  void domReady(){
    service = document.querySelector("#service");
    name = Project.getName(projectHash, service, (name) {
      this.name = name;
    });
  }
}