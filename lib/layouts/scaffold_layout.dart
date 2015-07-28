
import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'dart:html';

@CustomTag('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  CompetencesService service;
  @published String selected;
  @published String menu;
  @published String projectHash;

  ScaffoldLayout.created() : super.created();

  void domReady(){
    service = document.querySelector("#service");
  }

}