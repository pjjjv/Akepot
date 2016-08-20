@HtmlImport('menu_project.html')
library akepot.lib.menu.menu_project;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';

@PolymerRegister('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @property String selectedSection;
  @property String projectHash;
  CompetencesService service;
  bool isAdmin = false;

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){
    if(service.categories.isNotEmpty) return;
    Project.getCategoryNames(projectHash, service, (List<Category> categories) {
      service.categories = categories;
    });
    Project.isAdmin(projectHash, service.user.uid, service, (bool isAdmin){
      this.isAdmin = isAdmin;
    });
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}