
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_animation_group.dart';
import 'package:core_elements/core_animation.dart';
import 'dart:html';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement with ChangeNotifier  {
  SingleStrengthItem.created() : super.created();

  CoreAnimationGroup animation;
  HtmlElement descEl;
  bool hidden = true;
  @reflectable @published String get title => __$title; String __$title = "Software impact analysis"; @reflectable set title(String value) { __$title = notifyPropertyChange(#title, __$title, value); }
  @reflectable @published String get desc => __$desc; String __$desc = "Document that describes software impact analysis."; @reflectable set desc(String value) { __$desc = notifyPropertyChange(#desc, __$desc, value); }
  @reflectable @published int get number => __$number; int __$number = 1; @reflectable set number(int value) { __$number = notifyPropertyChange(#number, __$number, value); }

  domReady() {
    animation = shadowRoot.querySelector('#slide-down');
    animation.target = shadowRoot.querySelector('#desc');
    descEl = shadowRoot.querySelector('#desc');

    descEl.hidden = !descEl.hidden;
    String height = descEl.contentEdge.height.toString()+"px";
    descEl.hidden = !descEl.hidden;
    CoreAnimationProp prop = shadowRoot.querySelector('#slide-down-prop');
    prop.value = "translate(0,-$height)";
  }

  void toggleDesc(Event e){
    print('dispatching from child');
    //dispatchEvent(new CustomEvent('toggleotherdescs'));

    startToggleDesc();
  }

  void startToggleDesc(){
    animation.direction = (animation.direction == "reverse") ? "normal" : "reverse";
    hidden = descEl.hidden;

    if (hidden){
      descEl.hidden = !descEl.hidden;
    }
    animation.play();
  }

  void finishToggleDesc(Event e){
    if (!hidden){
      descEl.hidden = !descEl.hidden;
    }
  }

  void setDescHidden(){
    if(!descEl.hidden){
      startToggleDesc();
    }
  }
}
