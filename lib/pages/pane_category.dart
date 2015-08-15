
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';

@CustomTag('pane-category')
class PaneCategory extends PolymerElement {
  PaneCategory.created() : super.created();

  @published List<SubCategory> subcategories;
}