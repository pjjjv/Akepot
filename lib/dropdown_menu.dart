@HtmlImport('dropdown_menu.html')
library akepot.lib.dropdown_menu;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/competences_service.dart';
import 'package:akepot/login_screen.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_menu_button.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/iron_dropdown.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:polymer_elements/iron_meta.dart';

@PolymerRegister('dropdown-menu')
class DropdownMenu extends PolymerElement {
  DropdownMenu.created() : super.created();

  CompetencesService service;

  attached(){
    service = new IronMeta().byKey('service');
  }

  @reflectable
  void about(Event e, var detail) {
    PaperDialog dialog = $$('#about-dialog');
    dialog.toggle();
  }

  @reflectable
  void signOut(Event e, var detail) {
    (document.querySelector("#loginscreen") as LoginScreen).signOut(e, detail);
    service.signedIn = false;
    service.user = new User();
  }
}
