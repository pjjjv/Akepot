
import 'package:polymer/polymer.dart';

@CustomTag('menu-admin')
class MenuAdmin extends PolymerElement {
  MenuAdmin.created() : super.created();

  @published String selectedSection;
}