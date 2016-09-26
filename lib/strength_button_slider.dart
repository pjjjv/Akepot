@HtmlImport('strength_button_slider.html')
library akepot.lib.strength_button_slider;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/strength_button.dart';

@PolymerRegister('strength-button-slider')
class StrengthButtonSlider extends PolymerElement {
  StrengthButtonSlider.created() : super.created();
  @property int max = 5;
  @property int selected = 3;

  @reflectable
  List<int> toArray(int max) {
    return new List<int>.generate(max + 1, (int index) => index);
  }

  @reflectable
  void select(Event e, var detail){
    selected = (e.target as StrengthButton).number;
  }

}
