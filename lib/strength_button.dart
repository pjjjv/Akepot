
import 'package:polymer/polymer.dart';

@CustomTag('strength-button')
class StrengthButton extends PolymerElement {
  StrengthButton.created() : super.created();
  @published int number = 0;

  void showToast() {
    //PaperToast toast = $['toast'];
    //toast.show();
  }
}
