
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:core_elements/core_animated_pages.dart';

@CustomTag("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created() {
  }

  @observable Project project;

  CompetencesService service;
  @published String projectHash = "";

  CoreAnimatedPages pages;
  @published int page = 0;

  @observable int category_nr = 0;
  @observable int subcategory_nr = 0;
  @observable int competence_nr = 0;

  void domReady() {
    service = document.querySelector("#service");
    page = 0;
    pages = shadowRoot.querySelector("#pages_edit");

    project = toObservable(new Project.retrieve(projectHash, service));
  }

  void removeProject(Event e, var detail, Node target){
    //
  }

  void addCategory(Event e, var detail, Node target){
    project.addCategory();
  }

  void removeCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(category_nr >= index){
      category_nr = 0;
    }
    project.removeCategory(index);
  }

  void onCategoryTap(Event e, var detail, Node target){
    category_nr = int.parse(detail);
    pages.selectNext(false);
  }

  void addSubCategory(Event e, var detail, Node target){
    project.categories[category_nr].addSubCategory();
  }

  void removeSubCategory(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(subcategory_nr >= index){
      if(project.categories[category_nr].subcategories.length <= 1){
        goUp(e, detail, target);
      }
      subcategory_nr = 0;
    }
    project.categories[subcategory_nr].removeSubCategory(index);
  }

  void onSubCategoryTap(Event e, var detail, Node target){
    subcategory_nr = int.parse(detail);
    pages.selectNext(false);
  }

  void addCompetence(Event e, var detail, Node target){
    project.categories[category_nr].subcategories[subcategory_nr].addCompetence();
  }

  void removeCompetence(Event e, var detail, Node target){
    int index = int.parse(detail);
    if(competence_nr >= index){
      if(project.categories[category_nr].subcategories[subcategory_nr].competences.length <= 1){
        goUp(e, detail, target);
      }
      competence_nr = 0;
    }
    project.categories[category_nr].subcategories[subcategory_nr].removeCompetence(index);
  }

  void onCompetenceTap(Event e, var detail, Node target){
    competence_nr = int.parse(detail);
    pages.selectNext(false);
  }

  void goUp(Event e, var detail, HtmlElement target){
    pages.selectPrevious(false);
  }

}