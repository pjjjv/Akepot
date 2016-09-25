@HtmlImport('scaffold_layout.html')
library akepot.lib.layouts.scaffold_layout;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/app_layout/app_drawer_layout/app_drawer_layout.dart';
import 'package:polymer_elements/app_layout/app_drawer/app_drawer.dart';
import 'package:polymer_elements/app_layout/app_header/app_header.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/app_layout/app_header_layout/app_header_layout.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/app_layout/app_scroll_effects/effects/waterfall.dart';

@PolymerRegister('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  @property String selected;
  @property String menu;
  @property String projectHash;

  ScaffoldLayout.created() : super.created();


}
