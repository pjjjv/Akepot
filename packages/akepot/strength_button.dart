
import 'package:polymer/polymer.dart';

@CustomTag('strength-button')
class StrengthButton extends PolymerElement with ChangeNotifier  {
  StrengthButton.created() : super.created();
  @reflectable @published int get number => __$number; int __$number = 0; @reflectable set number(int value) { __$number = notifyPropertyChange(#number, __$number, value); }
  @reflectable @published bool get selected => __$selected; bool __$selected = false; @reflectable set selected(bool value) { __$selected = notifyPropertyChange(#selected, __$selected, value); }
}
