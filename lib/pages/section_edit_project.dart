
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'dart:js';
import 'package:paper_elements/paper_button.dart';

@CustomTag("section-edit-project")
class SectionEditProject extends PolymerElement {
  SectionEditProject.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  //@observable Project project;
  @observable List<Category> categories = [];
  @published int page;
  @published int index;

  PaperButton createButton;

  void domReady() {
    //service = document.querySelector("#service");
    /*createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);*/
  }

  void onItemTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "categorytap", "data": target.id } );
  }
}