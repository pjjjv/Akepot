@HtmlImport('section_edit_team.html')
library akepot.lib.pages.section_edit_team;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_team.dart';
import 'dart:html';
import 'package:akepot/core_card3.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:akepot/model/model_person.dart';

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

  void ready() {
  }

  @reflectable
  void onItemDeleteButtonTap(Event e, var detail){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeperson", "data": target.parent.id } );
  }

  @reflectable
  void goUp(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "goup2" } );
  }


  @reflectable
  bool computeCrossFadeDelayed1(int page){
    return (page != 0);
  }

  @reflectable
  bool computeCrossFadeDelayed2(int index, int page, Person person){
    return page != 1 || person.index != index;
  }
}
