@HtmlImport('scaffold_layout.html')
library akepot.lib.layouts.scaffold_layout;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  @property String selected;
  @property String menu;
  @property String projectHash;

  ScaffoldLayout.created() : super.created();


}