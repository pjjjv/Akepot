
import 'package:polymer/polymer.dart';

@CustomTag('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  ScaffoldLayout.created() : super.created();

  @published String selected;
  @published String menu;
}