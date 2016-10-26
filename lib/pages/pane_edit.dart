@HtmlImport('pane_edit.html')
library akepot.lib.pages.pane_edit;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/pages/section_edit_project.dart';
import 'package:akepot/pages/section_edit_project2.dart';
import 'package:akepot/pages/section_edit_project3.dart';
import 'package:akepot/pages/section_edit_category.dart';
import 'package:akepot/pages/section_edit_subcategory.dart';
import 'package:akepot/pages/section_edit_competence.dart';
import 'package:akepot/pages/section_edit_team.dart';
import 'package:akepot/pages/section_edit_role.dart';
import 'dart:html';
import 'package:observe/observe.dart' as observe;
import 'package:akepot/competences_service.dart';
import 'package:polymer_elements/neon_animated_pages.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'dart:developer';

@PolymerRegister("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created() {
  }

  CompetencesService service;
  @property String projectHash = "";
  @Property(notify: true, observer: 'selectedChanged') bool selected;

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

  bool signInDone = false;

  @reflectable
  void selectedChanged(bool selected, bool old) {
    if(signInDone && selected==true && (old==false || old==null)){
      start();
    }
  }

  @reflectable
  void signedIn(Event e, var detail){
    signInDone = true;
    if(selected){
      start();
    }
  }

  void start(){
    service = new IronMeta().byKey('service');
    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = observe.toObservable(new Project.retrieve(projectHash, service));
  }

  @reflectable
  void removeProject(Event e, var detail, Node target){
    //
  }

  @reflectable
  void addRole(Event e, var detail, Node target){
    service.project.addRole();
  }

  @reflectable
  void removeRole(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(role_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      role_nr = 0;
    }
    service.project.removeRole(index);
  }

  @reflectable
  void onRoleTap(Event e, var detail, Node target){
    role_nr = int.parse(detail);
    pages3 = $$("#pages_edit3");
    pages3.selectNext();
  }

  @reflectable
  void addTeam(Event e, var detail, Node target){
    service.project.addTeam();
  }

  @reflectable
  void removeTeam(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(team_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      team_nr = 0;
    }
    service.project.removeTeam(index);
  }

  @reflectable
  void onTeamTap(Event e, var detail, Node target){
    team_nr = int.parse(detail);
    pages2 = $$("#pages_edit2");
    pages2.selectNext();
  }

  @reflectable
  void removePerson(Event e, var detail, Node target){
    int index = int.parse(detail);
    service.project.teams[team_nr].removePerson(index);
  }

  @reflectable
  void addCategory(Event e, var detail, Node target){
    service.project.addCategory();
  }

  @reflectable
  void removeCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(category_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      category_nr = 0;
    }
    service.project.removeCategory(index);
  }

  @reflectable
  void onCategoryTap(Event e, var detail, Node target){
    category_nr = int.parse(detail);
    pages = $$("#pages_edit");
    pages.selectNext();
  }

  @reflectable
  void addSubCategory(Event e, var detail, Node target){
    service.project.categories[category_nr].addSubCategory();
  }


  @reflectable
  void removeSubCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(subcategory_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      subcategory_nr = 0;
    }
    service.project.categories[category_nr].removeSubCategory(index);
  }


  @reflectable
  void onSubCategoryTap(Event e, var detail, Node target){
    subcategory_nr = int.parse(detail);
    pages = $$("#pages_edit");
    pages.selectNext();
  }

  @reflectable
  void addCompetenceTemplate(Event e, var detail, Node target){
    service.project.categories[category_nr].subcategories[subcategory_nr].addCompetenceTemplate();
  }

  @reflectable
  void removeCompetenceTemplate(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(competence_nr >= index){//TODO: not really needed, reduces harmless errors on polymer expressions but does not remove them entirely
      competence_nr = 0;
    }
    service.project.categories[category_nr].subcategories[subcategory_nr].removeCompetenceTemplate(index);
  }

  @reflectable
  void onCompetenceTemplateTap(Event e, var detail, Node target){
    competence_nr = int.parse(detail);
    pages = $$("#pages_edit");
    pages.selectNext();
  }

  @reflectable
  void goUp(Event e, var detail, HtmlElement target){
    pages = $$("#pages_edit");
    pages.selectPrevious();
  }

  @reflectable
  void goUp2(Event e, var detail, HtmlElement target){
    pages2 = $$("#pages_edit2");
    pages2.selectPrevious();
  }

  @reflectable
  void goUp3(Event e, var detail, HtmlElement target){
    pages3 = $$("#pages_edit3");
    pages3.selectPrevious();
  }

}
