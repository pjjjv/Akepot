
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/strength_button.dart';

@CustomTag('strength-button-slider')
class StrengthButtonSlider extends PolymerElement with ChangeNotifier  {
  StrengthButtonSlider.created() : super.created();
  @reflectable @published int get max => __$max; int __$max = 5; @reflectable set max(int value) { __$max = notifyPropertyChange(#max, __$max, value); }
  @reflectable @published int get selected => __$selected; int __$selected = 3; @reflectable set selected(int value) { __$selected = notifyPropertyChange(#selected, __$selected, value); }

  List<int> toArray(int max) {
    return new List<int>.generate(max + 1, (int index) => index);
  }

  void select(Event e){
    selected = (e.target as StrengthButton).number;
  }

}
