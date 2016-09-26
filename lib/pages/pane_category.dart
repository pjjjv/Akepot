@HtmlImport('pane_category.html')
library akepot.lib.pane_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/subcategory_card.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

@PolymerRegister('pane-category')
class PaneCategory extends PolymerElement {
  PaneCategory.created() : super.created();

  @property List<SubCategory> subcategories;
}
