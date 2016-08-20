@HtmlImport('menu_home.html')
library akepot.lib.menu.menu_home;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('menu-home')
class MenuHome extends PolymerElement {
  MenuHome.created() : super.created();

  @property String selectedSection;
}