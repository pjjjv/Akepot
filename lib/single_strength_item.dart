@HtmlImport('single_strength_item.html')
library akepot.lib.single_strength_item;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:polymer_elements/iron_collapse.dart';

@PolymerRegister('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();

  @property String title = "Software impact analysis";
  @property String desc = "Document that describes software impact analysis.";
  @property int number = 1;
  IronCollapse cc;

  void domReady() {
    cc = $$("iron-collapse");
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
