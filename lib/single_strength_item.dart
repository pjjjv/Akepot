
import 'package:polymer/polymer.dart';

@CustomTag('single-strength-item')
class SingleStrengthItem extends PolymerElement {
  SingleStrengthItem.created() : super.created();

  @published String title = "Software impact analysis";
  @published String desc = "Document that describes software impact analysis.";
  @published int number = 1;
}
