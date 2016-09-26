@HtmlImport('section_edit_competence.html')
library akepot.lib.pages.section_edit_competence;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_competencetemplate.dart';
import 'dart:html';
import 'package:akepot/core_card3.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

@PolymerRegister("section-edit-competence")
class SectionEditCompetence extends PolymerElement {
  SectionEditCompetence.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));*/
  }

  @property CompetenceTemplate competenceTemplate;
  @property int page;

  void ready() {
  }

  @reflectable
  void goUp(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "goup" } );
  }
}
