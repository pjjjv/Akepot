@HtmlImport('page_edit.html')
library akepot.lib.pages.page_edit;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:akepot/pages/pane_edit.dart';
import 'package:akepot/menu/title_page.dart';

@PolymerRegister('page-edit')
class PageEdit extends PolymerElement {

  PageEdit.created() : super.created();

  @property String projectHash;

}
