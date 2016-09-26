@HtmlImport('strength_button.html')
library akepot.lib.strength_button;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_button.dart';

@PolymerRegister('strength-button')
class StrengthButton extends PolymerElement {
  StrengthButton.created() : super.created();
  @property int number = 0;
  @property bool selected = false;
  @property int threshold = 0;
  @property bool limited = false;
}
