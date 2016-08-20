@HtmlImport('menu_admin.html')
library akepot.lib.menu.menu_admin;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:app_router/app_router.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:akepot/competences_service.dart';

@PolymerRegister('menu-admin')
class MenuAdmin extends PolymerElement {
  MenuAdmin.created() : super.created();

  @property String selectedSection;
  @property String projectHash;
  String newlink;

  void domReady() {
    PaperItem createButton = shadowRoot.querySelector("#menu_button_create");
    createButton.hidden = false;
    createButton.onClick.listen(showDialog);
  }

  void showDialog(Event e){
    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/${projectHash}";
    if (DEBUG) print("New project link would be: $newlink");

    PaperDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/${projectHash}");
  }
}