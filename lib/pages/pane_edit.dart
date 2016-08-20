@HtmlImport('pane_edit.html')
library akepot.lib.pages.pane_edit;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import 'package:akepot/competences_service.dart';
import 'package:polymer_elements/neon_animated_pages.dart';

@PolymerRegister("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created() {
  }

  CompetencesService service;
  @property String projectHash = "";

  NeonAnimatedPages pages;
  NeonAnimatedPages pages2;
  NeonAnimatedPages pages3;
  int page = 0;
  int page2 = 0;
  int page3 = 0;
  int tab = 0;

  int category_nr = 0;
  int subcategory_nr = 0;
  int competence_nr = 0;
  int team_nr = 0;
  int role_nr = 0;

  void domReady() {
    service = document.querySelector("#service");
    page = 0;
    page2 = 0;

    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = toObservable(new Project.retrieve(projectHash, service));
  }

  void removeProject(Event e, var detail, Node target){
    //
  }

  void addRole(Event e, var detail, Node target){
    service.project.addRole();
  }

  void removeRole(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(role_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      role_nr = 0;
    }
    service.project.removeRole(index);
  }

  void onRoleTap(Event e, var detail, Node target){
    role_nr = int.parse(detail);
    pages3 = shadowRoot.querySelector("#pages_edit3");
    pages3.selectNext(false);
  }

  void addTeam(Event e, var detail, Node target){
    service.project.addTeam();
  }

  void removeTeam(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(team_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      team_nr = 0;
    }
    service.project.removeTeam(index);
  }

  void onTeamTap(Event e, var detail, Node target){
    team_nr = int.parse(detail);
    pages2 = shadowRoot.querySelector("#pages_edit2");
    pages2.selectNext(false);
  }

  void removePerson(Event e, var detail, Node target){
    int index = int.parse(detail);
    service.project.teams[team_nr].removePerson(index);
  }

  void addCategory(Event e, var detail, Node target){
    service.project.addCategory();
  }

  void removeCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(category_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      category_nr = 0;
    }
    service.project.removeCategory(index);
  }

  void onCategoryTap(Event e, var detail, Node target){
    category_nr = int.parse(detail);
    pages = shadowRoot.querySelector("#pages_edit");
    pages.selectNext(false);
  }

  void addSubCategory(Event e, var detail, Node target){
    service.project.categories[category_nr].addSubCategory();
  }

  void removeSubCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(subcategory_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      subcategory_nr = 0;
    }
    service.project.categories[category_nr].removeSubCategory(index);
  }

  void onSubCategoryTap(Event e, var detail, Node target){
    subcategory_nr = int.parse(detail);
    pages = shadowRoot.querySelector("#pages_edit");
    pages.selectNext(false);
  }

  void addCompetenceTemplate(Event e, var detail, Node target){
    service.project.categories[category_nr].subcategories[subcategory_nr].addCompetenceTemplate();
  }

  void removeCompetenceTemplate(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(competence_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      competence_nr = 0;
    }
    service.project.categories[category_nr].subcategories[subcategory_nr].removeCompetenceTemplate(index);
  }

  void onCompetenceTemplateTap(Event e, var detail, Node target){
    competence_nr = int.parse(detail);
    pages = shadowRoot.querySelector("#pages_edit");
    pages.selectNext(false);
  }

  void goUp(Event e, var detail, HtmlElement target){
    pages = shadowRoot.querySelector("#pages_edit");
    pages.selectPrevious(false);
  }

  void goUp2(Event e, var detail, HtmlElement target){
    pages2 = shadowRoot.querySelector("#pages_edit2");
    pages2.selectPrevious(false);
  }

  void goUp3(Event e, var detail, HtmlElement target){
    pages3 = shadowRoot.querySelector("#pages_edit3");
    pages3.selectPrevious(false);
  }

}