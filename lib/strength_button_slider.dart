
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/strength_button.dart';

@CustomTag('strength-button-slider')
class StrengthButtonSlider extends PolymerElement {
  StrengthButtonSlider.created() : super.created();
  @published int max = 5;
  @published int selected = 3;

  List<int> toArray(int max) {
    return new List<int>.generate(max + 1, (int index) => index);
  }

  void select(Event e){
    selected = (e.target as StrengthButton).number;
  }

}
