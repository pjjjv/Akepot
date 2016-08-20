@HtmlImport('pane_category.html')
library akepot.lib.pane_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';

@PolymerRegister('pane-category')
class PaneCategory extends PolymerElement {
  PaneCategory.created() : super.created();

  @property List<SubCategory> subcategories;
}