
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag('menu-admin')
class MenuAdmin extends PolymerElement {
  MenuAdmin.created() : super.created();

  @published String selectedSection;
  @published String projectHash;
  @observable String newlink;

  void domReady() {
    PaperItem createButton = shadowRoot.querySelector("#menu_button_create");
    createButton.hidden = false;
    createButton.onClick.listen(showDialog);
  }

  void showDialog(Event e){
    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/${projectHash}";
    print("New project link would be: $newlink");

    PaperActionDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/${projectHash}");
  }
}