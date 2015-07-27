
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_team.dart';
import 'dart:html';

@CustomTag("section-edit-team")
class SectionEditTeam extends PolymerElement {
  SectionEditTeam.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @published Team team;
  @published int page;
  @published int index;

  void domReady() {
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removeperson", "data": target.parent.id } );
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "goup2" } );
  }
}