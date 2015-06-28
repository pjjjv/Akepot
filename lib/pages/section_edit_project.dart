
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';

@CustomTag("section-edit-project")
class SectionEditProject extends PolymerElement {
  SectionEditProject.created() : super.created() {

  }

  @observable Project project;
  @published int page;
  @published int index;

  void domReady() {
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "categorytap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "addcategory" } );
  }
}