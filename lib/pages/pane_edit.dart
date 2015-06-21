
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:async';
import 'package:paper_elements/paper_action_dialog.dart';
import 'package:core_elements/core_animated_pages.dart';

@CustomTag("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created() {
    project = new Project.empty(projectHash);

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @observable Project project;
  PaperButton createButton;

  CompetencesService service;
  @published String projectHash = "";
  @observable String newlink;

  CoreAnimatedPages pages;
  @published int page = 0;

  @observable List<Category> categories = [];
  @observable int category_nr = 0;
  @observable int subcategory_nr = 0;
  @observable int competence_nr = 0;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void domReady() {
    service = document.querySelector("#service");
    page = 0;
    pages = shadowRoot.querySelector("#pages_edit");
    copyProject(null, null, null);
    if(categories.isEmpty){//TODO
      startupForProject();
    }
    /*createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);*/
  }

  void copyProject(Event e, var detail, Node target){
    if(service == null) domReady();//TODO: why is service sometimes null?
    categories = service.categories;
  }



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

  void getProject(){
    print("getProject");
    service.getProject(projectHash);
  }




  void createProject(Event e){
    print ("createProject");
    project.categoriesFromJson();
    project.teamsFromJson();
    service.newProject(project, projectHash);
  }

  void showDialog(Event e, var detail, Node target){
    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/" + projectHash;
    print("New project link would be: $newlink");

    PaperActionDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }



  void onCategoryTap(Event e, var detail, Node target){
    category_nr = int.parse(detail);
    pages.selectNext(false);
    //var event = new JsObject.fromBrowserObject(e);
    //this.fire( "core-signal", detail: { "name": "categorytapped" } );
  }

  void addSubCategory(Event e, var detail, Node target){
    categories[category_nr].subcategories.add(new SubCategory.create());
    subcategory_nr = categories[category_nr].subcategories.length-1;
    //pages.selectNext(false);
  }

}