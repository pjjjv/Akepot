
import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'dart:html';

@CustomTag('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  CompetencesService service;
  @published String selected;
  @published String menu;
  @published String projectHash;
  @observable User user = new User();

  ScaffoldLayout.created() : super.created();

  void domReady(){
    service = document.querySelector("#service");
    copyUserInfo(null, null, null);
  }

  void copyUserInfo(Event e, var detail, Node target){
    user = service.user;
  }

}