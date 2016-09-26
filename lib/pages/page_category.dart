@HtmlImport('page_category.html')
library akepot.lib.pages.page_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:akepot/pages/panes_category.dart';
import 'package:akepot/menu/title_page.dart';

@PolymerRegister('page-category')
class PageCategory extends PolymerElement {

  PageCategory.created() : super.created();

  @Property(notify: true) String projectHash;
  @Property(notify: true) String selectedcategory;

}
