
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/model/model_project.dart';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
  @published String projectHash;
  @observable CompetencesService service;

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){
    Project project = new Project.retrieve(projectHash, service);//TODO: must not retrieve project twice in parallel, because will create Competence for a user twice.
    categories = project.categories;
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}