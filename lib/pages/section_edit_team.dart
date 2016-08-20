@HtmlImport('section_edit_team.html')
library akepot.lib.pages.section_edit_team;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_team.dart';
import 'dart:html';

@PolymerRegister("section-edit-team")
class SectionEditTeam extends PolymerElement {
  SectionEditTeam.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));*/
  }

  @property Team team;
  @property int page;
  @property int index;

  void domReady() {
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeperson", "data": target.parent.id } );
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "goup2" } );
  }
}