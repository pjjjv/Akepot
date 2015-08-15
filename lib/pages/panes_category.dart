
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';

@CustomTag('panes-category')
class PanesCategory extends PolymerElement {

  @observable CompetencesService service;
  @published String projectHash = "";
  @published var selected;
  @observable var selectedCategory;

  PanesCategory.created() : super.created();

  void selectedChanged(String name, var value, var listValue){
    selectedCategory = "$value";
  }

  void domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){
    Person.exists(service.user.uid, projectHash, service, (exists) {
      if (!exists){
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/join");
      }
    });

    if(service.project != null && service.project.hash == projectHash){
      return;
    } else {
      if(selected != "" && selected != null && selected != 0){
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
      }
    }

    service.project = new Project.retrieve(projectHash, service);
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}