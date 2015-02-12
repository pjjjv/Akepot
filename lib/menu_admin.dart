
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js';

@CustomTag('menu-admin')
class MenuAdmin extends PolymerElement {
  MenuAdmin.created() : super.created();

  @published String selectedSection;
  @published String projectHash;

  /*void navigate(Event e, var detail){
    var itemId = detail['item'].id;
    if(itemId == "menu_item_home"){
      context['MoreRouting'].callMethod('navigateTo', ['/']);
    }
  }*/
}