@HtmlImport('core_card2.html')
library akepot.lib.core_card2;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';

@PolymerRegister('core-card2')
class CoreCard2 extends PolymerElement {
  bool flipped = false;
  CoreCard2.created() : super.created();

  void ready() {
    HtmlElement flipContainer = $$('.flip-container');
    HtmlElement back = $$('#back');
    HtmlElement front = $$('#front');

    String height = front.client.height.toString()+"px";
    back.style.height = height;
    flipContainer.style.height = height;
  }

  @reflectable
  void flipBack(Event e, var detail){
    if (flipped || (e.target as HtmlElement).classes.contains("flip-button")) {
      flip(e, detail);
    }
  }

  @reflectable
  void flip(Event e, var detail){
    flipped = !flipped;
    var flip = $$('.flip');
    flip.classes.toggle('flipper');
  }
}
