
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_role.dart';
import 'dart:html';

@CustomTag("section-edit-role")
class SectionEditRole extends PolymerElement {
  SectionEditRole.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @published Role role;
  @published int page;

  void domReady() {
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "goup3" } );
  }
}