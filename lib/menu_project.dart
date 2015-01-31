
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';

@CustomTag('menu-project')
class MenuProject extends PolymerElement {
  MenuProject.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
}