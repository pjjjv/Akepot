
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_competence.dart';
import 'dart:html';

@CustomTag("section-edit-competence")
class SectionEditCompetence extends PolymerElement {
  SectionEditCompetence.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @published Competence competence;
  @published int page;

  void domReady() {
  }

  void goUp(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "goup" } );
  }
}