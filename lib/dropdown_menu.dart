@HtmlImport('dropdown_menu.html')
library akepot.lib.dropdown_menu;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/login_screen.dart';
import 'package:polymer_elements/paper_dialog.dart';

@PolymerRegister('dropdown-menu')
class DropdownMenu extends PolymerElement {
  DropdownMenu.created() : super.created();

  CompetencesService service;

  domReady(){
    service = document.querySelector("#service");
  }

  void about(Event e) {
    PaperDialog dialog = shadowRoot.querySelector('#about-dialog');
    dialog.toggle();
  }

  void signOut(Event e) {
    (document.querySelector("#loginscreen") as LoginScreen).signOut(e);
    service.signedIn = false;
    service.user = new User();
  }
}