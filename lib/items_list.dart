
import 'package:polymer/polymer.dart';
import 'package:akepot/single_strength_item.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';

@CustomTag('items-list')
class ItemsList extends PolymerElement {
  ItemsList.created() : super.created();

  @published List<SubCategory> subcategories;

  void toggleOtherDescs(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      print("toggleOtherDescs");
      item.setDescHidden();
    }
  }

  void subcategoriesChanged(Event e){
    print("subcategories.competences: ${subcategories[0].competences}");
  }
}