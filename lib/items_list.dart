
import 'package:polymer/polymer.dart';
import 'package:akepot/single_strength_item.dart';
import 'dart:html';

@CustomTag('items-list')
class ItemsList extends PolymerElement {
  ItemsList.created() : super.created();

  @observable List competences = null;

  void toggleOtherDescs(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      print("toggleOtherDescs");
      item.setDescHidden();
    }
  }
}