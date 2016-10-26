@HtmlImport('menu_home.html')
library akepot.lib.menu.menu_home;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

@PolymerRegister('menu-home')
class MenuHome extends PolymerElement {
  MenuHome.created() : super.created();

  @property String selectedSection;

}
