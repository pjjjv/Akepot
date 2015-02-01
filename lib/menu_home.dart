
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js';

@CustomTag('menu-home')
class MenuHome extends PolymerElement {
  MenuHome.created() : super.created();

  @published String selectedSection;

  void navigate(Event e, var detail){
    var itemId = detail['item'].id;
    if(itemId == "menu_item_home"){
      context['MoreRouting'].callMethod('navigateTo', ['/']);
    }
  }
}