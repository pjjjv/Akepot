
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published String selected;
  @observable String selectedSection;
  @published String projectHash;
  @observable CompetencesService service;

  void selectedChanged(String name, var oldValue, var newValue){
    selectedSection = "$oldValue";
  }

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){
    if(service.categories.isNotEmpty) return;
    Project.getCategoryNames(projectHash, service, (List<Category> categories) {
      service.categories = categories;
      selectedSection = "$selected";
    });
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}