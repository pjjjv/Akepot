
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js';

@CustomTag('menu-home')
class MenuHome extends PolymerElement {
  MenuHome.created() : super.created();

  @published String selectedSection;
}