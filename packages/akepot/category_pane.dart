
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';

@CustomTag('category-pane')
class CategoryPane extends PolymerElement with ChangeNotifier  {
  CategoryPane.created() : super.created();

  @reflectable @published List<SubCategory> get subcategories => __$subcategories; List<SubCategory> __$subcategories; @reflectable set subcategories(List<SubCategory> value) { __$subcategories = notifyPropertyChange(#subcategories, __$subcategories, value); }
}