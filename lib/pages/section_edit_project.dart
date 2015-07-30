
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag("section-edit-project")
class SectionEditProject extends PolymerElement {
  SectionEditProject.created() : super.created() {

  }

  @observable Project project;
  @published int page;
  @published int index;
  @observable String newlink;

  void domReady() {
    PaperButton createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(showDialog);
  }

  void showDialog(Event e){
    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/${project.hash}";
    print("New project link would be: $newlink");

    PaperActionDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/${project.hash}");
  }

  void onItemTap(Event e, var detail, HtmlElement target){
    this.fire( "core-signal", detail: { "name": "categorytap", "data": target.id } );
  }

  void onCreateButtonTap(Event e, var detail, Node target){
    this.fire( "core-signal", detail: { "name": "addcategory" } );
  }

  void onItemDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removecategory", "data": target.parent.id } );
  }

  void onProjectDeleteButtonTap(Event e, var detail, HtmlElement target){
    e.stopPropagation();
    this.fire( "core-signal", detail: { "name": "removeproject", "data": target.id } );
  }
}