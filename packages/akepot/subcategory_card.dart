
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/single_strength_item.dart';
import 'dart:html';

@CustomTag('subcategory-card')
class SubCategoryCard extends PolymerElement with ChangeNotifier  {
  SubCategoryCard.created() : super.created();

  @reflectable @published SubCategory get subcategory => __$subcategory; SubCategory __$subcategory; @reflectable set subcategory(SubCategory value) { __$subcategory = notifyPropertyChange(#subcategory, __$subcategory, value); }

  void toggleOtherDescs(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      print("toggleOtherDescs");
      item.setDescHidden();
    }
  }
}