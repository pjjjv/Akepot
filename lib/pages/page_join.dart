@HtmlImport('page_join.html')
library akepot.lib.pages.page_join;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:akepot/pages/pane_join.dart';
import 'package:akepot/menu/title_page.dart';

@PolymerRegister('page-join')
class PageJoin extends PolymerElement {

  PageJoin.created() : super.created();

  @property String projectHash;

}
