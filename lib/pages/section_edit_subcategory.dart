@HtmlImport('section_edit_subcategory.html')
library akepot.lib.pages.section_edit_subcategory;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';
import 'package:akepot/core_card3.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

@PolymerRegister("section-edit-subcategory")
class SectionEditSubCategory extends PolymerElement {
  SectionEditSubCategory.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));*/
  }

  @property SubCategory subCategory;
  @property int page;
  @property int index;

  void ready() {
  }

  @reflectable
  void onItemTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "competencetemplatetap", "data": target.id } );
  }

  @reflectable
  void onCreateButtonTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "addcompetencetemplate" } );
  }

  @reflectable
  void onItemDeleteButtonTap(Event e, var detail){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removecompetencetemplate", "data": target.parent.id } );
  }

  @reflectable
  void goUp(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "goup" } );
  }



  @reflectable
  bool computeCrossFadeDelayed1(int page){
    return (page != 1);
  }

  @reflectable
  bool computeHero(int index, int page, int rIndex){
    return (page == 3 || page == 2) && rIndex == index;
  }

  @reflectable
  bool computeCrossFadeDelayed2(int index, int page, int rIndex){
    return (page != 3 && page != 2) || rIndex != index;
  }
}
