
import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();

    //animation.target = document.getElementById('desc');

  //var animation = document.getElementById('slide-up');
  @published String title = "Software impact analysis";
  @published String desc = "Document that describes software impact analysis.";
  @published int number = 1;

  void toggleDesc(Event e){
    HtmlElement desc = shadowRoot.querySelector('#desc');
    //desc.classes.toggle('hidden');
    desc.hidden = !desc.hidden;
    //animation.play();
  }

  /*void setDescHidden(){

  }*/
}
