
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';

@CustomTag("section-edit-subcategory")
class SectionEditSubcategory extends PolymerElement {
  SectionEditSubcategory.created() : super.created() {

    /*HttpRequest.getString("data/fresh_categories.json")
    .then((String text) => project.categoriesAsJson = text)
    .catchError((Error error) => print("Error: $error"));

    HttpRequest.getString("data/fresh_teams.json")
    .then((String text) => project.teamsAsJson = text)
    .catchError((Error error) => print("Error: $error"));*/
  }

  @observable Project project;
  PaperButton createButton;

  void domReady() {
    //service = document.querySelector("#service");
    /*createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);*/
  }
}