library single_strength_item;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:core_elements/core_collapse.dart';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();

  @published String title = "Software impact analysis";
  @published String desc = "Document that describes software impact analysis.";
  @published int number = 1;
  CoreCollapse cc;

  void domReady() {
    cc = shadowRoot.querySelector("core-collapse");
  }

  void toggle(Event e) {
    //Toggle (close) all others
    if(!cc.opened){
      dispatchEvent(new CustomEvent('toggleotherdescs'));
    }

    cc.toggle();
  }

  void closeDesc(){
    //Close if open
    if(cc.opened){
      cc.toggle();
    }
  }

}
