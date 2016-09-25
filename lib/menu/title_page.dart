@HtmlImport('title_page.html')
library akepot.lib.menu.title_page;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';

@PolymerRegister('title-page')
class TitlePage extends PolymerElement {
  TitlePage.created() : super.created();

  CompetencesService service;
  @property String projectHash = "";
  @property String projectName = "";

  void ready(){
    service = $$("#service");
    projectName = projectHash;
    Project.getName(projectHash, service, (projectName) {
      this.projectName = projectName;
    });
  }
}
