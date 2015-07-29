
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';
import 'dart:async';

@CustomTag('panes-category')
class PanesCategory extends PolymerElement {

  @observable Project project;
  @observable CompetencesService service;
  @published String projectHash = "";
  @published String selectedCategory = "";

  PanesCategory.created() : super.created();

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void tap(){
    //just for debugging
    for(Category category in project.categories){
      for(SubCategory subcategory in category.subcategories){
        subcategory.listenForCompetences(service, project);
      }
    }
  }

  void signedIn(Event e, var detail, HtmlElement target){
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

    new Timer(SPLASH_TIMEOUT, tap);//TODO: solve need for timer
  }

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT = const Duration(milliseconds: MIN_SPLASH_TIME);

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}