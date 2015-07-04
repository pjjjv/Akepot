
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';

@CustomTag("section-edit-subcategory")
class SectionEditSubCategory extends PolymerElement {
  SectionEditSubCategory.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @published SubCategory subCategory;
  @published int page;
  @published int index;

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "competencetap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "addcompetence" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removecompetence", "data": target.parent.id } );
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "goup" } );
  }
}