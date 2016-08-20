@HtmlImport('scaffold_layout.html')
library akepot.lib.layouts.scaffold_layout;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/competences_service.dart';
import 'dart:html';

@PolymerRegister('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  CompetencesService service;
  @property String selected;
  @property String menu;
  @property String projectHash;

  ScaffoldLayout.created() : super.created();

  void domReady(){
    service = document.querySelector("#service");
  }

}