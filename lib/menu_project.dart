
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import 'dart:html';
import 'dart:js';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
  @published String projectHash;

  void navigate(Event e, var detail){
    var itemId = detail['item'].id;
    if(itemId == "menu_item_home"){
      context['MoreRouting'].callMethod('navigateTo', ['/']);
    }
  }
}