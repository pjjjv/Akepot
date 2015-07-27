
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';

@CustomTag('panes-category')
class PanesCategory extends PolymerElement {

  @observable Project project;
  CompetencesService service;
  @published String projectHash = "";
  @published String selectedCategory = "";

  PanesCategory.created() : super.created();

  domReady(){
    service = document.querySelector("#service");

    project = new Project.retrieve(projectHash, service);

    Person.exists(service.user.uid, service, (exists) {
      if (!exists){
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/join");
      }
    });
    /*if(project != null && !project.categories.isEmpty && (selectedCategory == "" || selectedCategory == null)){
      String newSelectedCategory = encodeUriComponent(project.categories.first.name);
      (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/category/$newSelectedCategory");
    }*/ //TODO
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}