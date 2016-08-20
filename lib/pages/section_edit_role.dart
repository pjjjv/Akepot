@HtmlImport('section_edit_role.html')
library akepot.lib.pages.section_edit_role;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_role.dart';
import 'dart:html';

@PolymerRegister("section-edit-role")
class SectionEditRole extends PolymerElement {
  SectionEditRole.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));*/
  }

  @property Role role;
  @property int page;

  void domReady() {
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "goup3" } );
  }
}