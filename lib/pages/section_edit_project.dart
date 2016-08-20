@HtmlImport('section_edit_project.html')
library akepot.lib.pages.section_edit_project;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';

@PolymerRegister("section-edit-project")
class SectionEditProject extends PolymerElement {
  SectionEditProject.created() : super.created() {

  }

  @property Project project;
  @property int page;
  @property int index;

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "iron-signal", detail: { "name": "categorytap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "iron-signal", detail: { "name": "addcategory" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removecategory", "data": target.parent.id } );
  }

  void onProjectDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeproject", "data": target.id } );
  }
}