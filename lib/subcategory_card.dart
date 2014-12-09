
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/single_strength_item.dart';
import 'dart:html';

@CustomTag('subcategory-card')
class SubCategoryCard extends PolymerElement {
  SubCategoryCard.created() : super.created();

  @published SubCategory subcategory;

  void toggleOtherDescs(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      print("toggleOtherDescs");
      item.setDescHidden();
    }
  }
}