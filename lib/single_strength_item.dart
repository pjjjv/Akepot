
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_animation_group.dart';
import 'dart:html';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();

  domReady() {
    animation = shadowRoot.querySelector('#slide-down');
    animation.target = shadowRoot.querySelector('#desc');
    descEl = shadowRoot.querySelector('#desc');
  }
  CoreAnimationGroup animation;
  HtmlElement descEl;
  bool hidden = true;
  @published String title = "Software impact analysis";
  @published String desc = "Document that describes software impact analysis.";
  @published int number = 1;

  void toggleDesc(Event e){
    //desc.style.opacity = (desc.style.opacity == "1") ? "0" : "1";

    //var animationtarget = animation.target;
    //print("target $animationtarget");
    animation.direction = (animation.direction == "reverse") ? "normal" : "reverse";
    hidden = descEl.hidden;

    if (hidden){
      //desc.style.opacity="0";
      descEl.hidden = !descEl.hidden;
      print("show");
      //print("before unhide dir: "+animation.direction.toString()+" op: "+desc.style.opacity.toString());
    }else{
      //desc.style.opacity="1";
    }
    print("before dir: "+animation.direction.toString()+" op: "+descEl.style.opacity.toString());
    animation.play();
  }

  void finishToggleDesc(Event e){
    if (!hidden){
      //desc.style.opacity="0";
      descEl.hidden = !descEl.hidden;
      print("hide");
      //print("after hide dir: "+animation.direction.toString()+" op: "+desc.style.opacity.toString());
    }else{
      //desc.style.opacity="1";
    }
    //print("after");
    //desc.style.zIndex = "-1";
    //print("after dir: "+animation.direction.toString()+" op: "+desc.style.opacity.toString());
    //hidden = !hidden;
  }

  void setDescHidden(){

  }
}
