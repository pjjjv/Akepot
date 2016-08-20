@HtmlImport('panes_category.html')
library akepot.lib.pages.panes_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';

@PolymerRegister('panes-category')
class PanesCategory extends PolymerElement {

  CompetencesService service;
  @property String projectHash = "";
  @property String selectedCategory = "";//Bugfix: needs to be assigned "", to prevent it from being 0.

  PanesCategory.created() : super.created();

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
      if(selectedCategory != "" && selectedCategory != null){
        //If we come in through a direct category link, then go back to main project page (no category).
        //Bugfix: We do this to avoid a bug, where core-selector (extended by core-animated-pages) is unable to deal with changing content. We would have to set selected again after everything is loaded from firebase, but we don't know when that is.
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
      }
    }

    service.project = new Project.retrieve(projectHash, service);
  }
}