
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
  @published String selectedSection;

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
      (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/$newSelectedCategory");

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
      //projectHash = projectRoute['projectHash'];
      getProject();
    }
  }

  void completeGetProject () {
    if(categories.isEmpty == true && service.newuser == false){
      startGetProject(false);
      return;
    }
    if(categories.isEmpty == false){
      selectedSection = categories.first.name;
    }
    copyProject(null, null, null);
    if(service.newuser == true){
      (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/join");
    }
  }

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
  }
}