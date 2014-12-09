
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';

@CustomTag('category-pane')
class CategoryPane extends PolymerElement {
  CategoryPane.created() : super.created();

  @published List<SubCategory> subcategories;
}