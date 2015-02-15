
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/competences_service.dart';
import 'dart:async';
import 'package:app_router/app_router.dart';

@CustomTag('panes-category')
class PanesCategory extends PolymerElement {

  @observable List<Category> categories = [];
  CompetencesService service;
  @published String projectHash = "";
  @published String selectedCategory = "";

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  PanesCategory.created() : super.created();

  domReady(){
    service = document.querySelector("#service");
    copyProject(null, null, null);
    if(categories.isEmpty){//TODO
      startupForProject();
    }
  }

  void copyProject(Event e, var detail, Node target){
    categories = service.categories;
    if(!categories.isEmpty && (selectedCategory == "" || selectedCategory == null)){
      String newSelectedCategory = encodeUriComponent(categories.first.name);
      (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/category/$newSelectedCategory");
    }
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);


  void startupForProject () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartupForProject);
  }

  void completeStartupForProject () {
    if(service.signedin == false){
      startupForProject();
      return;
    }
    startGetProject(true);
  }

  void startGetProject (bool first) {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeGetProject);
    if (first) {
      getProject();
    }
  }

  void completeGetProject () {
    if(categories.isEmpty == true){
      startGetProject(false);
      return;
    }
    copyProject(null, null, null);
  }

  void newUser(Event e, var detail, Node target){
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/join");
  }

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
  }
}