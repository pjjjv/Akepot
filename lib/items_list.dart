
import 'package:polymer/polymer.dart';
import 'package:akepot/single_strength_item.dart';
import 'dart:html';
// Import the DiConsume mixin.
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('items-list')
class ItemsList extends PolymerElement with di.DiConsumer {
  ItemsList.created() : super.created();

  @observable List competences = null;

  void toggleOtherDescs(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      print("toggleOtherDescs");
      item.setDescHidden();
    }
  }
}