
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_role.dart';
import 'dart:html';

@CustomTag("section-edit-project3")
class SectionEditProject3 extends PolymerElement {
  SectionEditProject3.created() : super.created() {

  }

  @published Project project;
  @published int page;
  @published int index;

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "roletap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "addrole" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removerole", "data": target.parent.id } );
  }

  void onProjectDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removeproject", "data": target.id } );
  }
}