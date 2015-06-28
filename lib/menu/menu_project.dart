
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'dart:js';
import 'package:akepot/competences_service.dart';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
  @published String projectHash;
  CompetencesService service;

  domReady(){
    service = document.querySelector("#service");
    //copyProject(null, null, null);//TODO: disabled menu
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);

  void copyProject(Event e, var detail, Node target){
    if(service == null) domReady();//TODO: why is service sometimes null?
    categories = service.project.categories;
  }
}