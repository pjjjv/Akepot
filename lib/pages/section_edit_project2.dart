@HtmlImport('section_edit_project2.html')
library akepot.lib.pages.section_edit_project2;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';

@PolymerRegister("section-edit-project2")
class SectionEditProject2 extends PolymerElement {
  SectionEditProject2.created() : super.created() {

  }

  @property Project project;
  @property int page;
  @property int index;

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "teamtap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "iron-signal", detail: { "name": "addteam" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeteam", "data": target.parent.id } );
  }

  void onProjectDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeproject", "data": target.id } );
  }
}
