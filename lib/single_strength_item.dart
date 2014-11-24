
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_animation_group.dart';
import 'dart:html';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();
  @published String title = "Software impact analysis";
  @published String desc = "Document that describes software impact analysis.";
  @published int number = 1;

  void toggleDesc(Event e){
    HtmlElement desc = shadowRoot.querySelector('#desc');
    //desc.style.opacity = (desc.style.opacity == "1") ? "0" : "1";

    CoreAnimationGroup animation = shadowRoot.querySelector('#slide-down');
    animation.target = shadowRoot.querySelector('#desc');
    var animationtarget = animation.target;
    //print("target $animationtarget");
    animation.direction = (animation.direction == "reverse") ? "normal" : "reverse";
    bool hidden = desc.hidden;

    print("before op: "+desc.style.opacity.toString());
    if (hidden){
      desc.hidden = !desc.hidden;
      print("before unhide dir: "+animation.direction.toString()+" op: "+desc.style.opacity.toString());
    }else{
      desc.style.opacity="1";
    }
    animation.play();
    if (!hidden){
      desc.hidden = !desc.hidden;
      print("after hide dir: "+animation.direction.toString()+" op: "+desc.style.opacity.toString());
    }else{
      desc.style.opacity="1";
    }
    print("after op: "+desc.style.opacity.toString());
  }

  void setDescHidden(){

  }
}
