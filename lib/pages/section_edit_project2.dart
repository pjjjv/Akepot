
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_team.dart';
import 'dart:html';

@CustomTag("section-edit-project2")
class SectionEditProject2 extends PolymerElement {
  SectionEditProject2.created() : super.created() {

  }

  @published Project project;
  @published int page;
  @published int index;

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "teamtap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "addteam" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removeteam", "data": target.parent.id } );
  }

  void onProjectDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removeproject", "data": target.id } );
  }
}