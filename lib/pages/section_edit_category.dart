@HtmlImport('section_edit_category.html')
library akepot.lib.pages.section_edit_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'package:akepot/core_card3.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:akepot/model/model_subcategory.dart';

@PolymerRegister("section-edit-category")
class SectionEditCategory extends PolymerElement {
  SectionEditCategory.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => if (DEBUG) print("Error: $error"));*/
  }

  @property Category category;
  @property int page;
  @property int index;

  void ready() {
  }

  @reflectable
  void onItemTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "subcategorytap", "data": target.id } );
  }

  @reflectable
  void onCreateButtonTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "addsubcategory" } );
  }

  @reflectable
  void onItemDeleteButtonTap(Event e, var detail){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removesubcategory", "data": target.parent.id } );
  }

  @reflectable
  void goUp(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "goup" } );
  }


  @reflectable
  bool computeCrossFadeDelayed1(int page){
    return (page != 0);
  }

  @reflectable
  bool computeHero(int index, int page, SubCategory subcategory){
    return (page == 2 || page == 1) && subcategory.index == index;
  }

  @reflectable
  bool computeCrossFadeDelayed2(int index, int page, SubCategory subcategory){
    return page != 1 || subcategory.index != index;
  }
}
