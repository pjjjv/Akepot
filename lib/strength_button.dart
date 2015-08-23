
import 'package:polymer/polymer.dart';

@CustomTag('strength-button')
class StrengthButton extends PolymerElement {
  StrengthButton.created() : super.created();
  @published int number = 0;
  @published bool selected = false;
  @published int threshold = 0;
  @published bool limited = false;
}
