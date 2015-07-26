
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'dart:js';
import 'package:akepot/competences_service.dart';
import 'package:akepot/model/model_project.dart';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
  @published String projectHash;
  CompetencesService service;

  domReady(){
    service = document.querySelector("#service");
    // copy project
    Project project = new Project.retrieve(projectHash, service);
    categories = project.categories;
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}