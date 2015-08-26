
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/login_screen.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag('dropdown-menu')
class DropdownMenu extends PolymerElement {
  DropdownMenu.created() : super.created();

  @observable CompetencesService service;

  domReady(){
    service = document.querySelector("#service");
  }

  void about(Event e) {
    PaperActionDialog dialog = shadowRoot.querySelector('#about-dialog');
    dialog.toggle();
  }

  void signOut(Event e) {
    (document.querySelector("#loginscreen") as LoginScreen).signOut(e);
    service.signedIn = false;
    service.user = new User();
  }
}