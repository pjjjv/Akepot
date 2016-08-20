@HtmlImport('core_card2.html')
library akepot.lib.core_card2;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';

@PolymerRegister('core-card2')
class CoreCard2 extends PolymerElement {
  bool flipped = false;
  CoreCard2.created() : super.created();

  void domReady() {
    HtmlElement flipContainer = shadowRoot.querySelector('.flip-container');
    HtmlElement back = shadowRoot.querySelector('#back');
    HtmlElement front = shadowRoot.querySelector('#front');

    String height = front.client.height.toString()+"px";
    back.style.height = height;
    flipContainer.style.height = height;
  }

  void flipBack(Event e){
    if (flipped || (e.target as HtmlElement).classes.contains("flip-button")) {
      flip(e);
    }
  }

  void flip(Event e){
    flipped = !flipped;
    var flip = shadowRoot.querySelector('.flip');
    flip.classes.toggle('flipper');
  }
}