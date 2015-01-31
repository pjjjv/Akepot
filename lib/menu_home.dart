
import 'package:polymer/polymer.dart';

@CustomTag('menu-home')
class MenuHome extends PolymerElement {
  MenuHome.created() : super.created();

  @published String selectedSection;
}