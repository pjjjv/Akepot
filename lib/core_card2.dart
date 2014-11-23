
import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('core-card2')
class CoreCard2 extends PolymerElement {
  bool flipped = false;
  CoreCard2.created() : super.created();

  void domReady() {
    HtmlElement flipContainer = shadowRoot.querySelector('.flip-container');
    HtmlElement back = shadowRoot.querySelector('#back');
    HtmlElement front = shadowRoot.querySelector('#front');

    String height = front.client.height.toString()+"px";
    print("heiht: $height");
    back.style.height = height;
    flipContainer.style.height = height;
  }

  void flipBack(Event e){
    if (flipped || (e.target as HtmlElement).id=="help-button") {
      flip(e);
    }
  }

  void flip(Event e){
    flipped = !flipped;
    var flip = shadowRoot.querySelector('.flip');
    flip.classes.toggle('flipper');
  }
}