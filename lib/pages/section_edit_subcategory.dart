@HtmlImport('section_edit_subcategory.html')
library akepot.lib.pages.section_edit_subcategory;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';

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

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "competencetemplatetap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "iron-signal", detail: { "name": "addcompetencetemplate" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removecompetencetemplate", "data": target.parent.id } );
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "goup" } );
  }
}