@HtmlImport('section_edit_category.html')
library akepot.lib.pages.section_edit_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';

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

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "subcategorytap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "iron-signal", detail: { "name": "addsubcategory" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removesubcategory", "data": target.parent.id } );
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "goup" } );
  }
}