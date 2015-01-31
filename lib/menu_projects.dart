
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';

@CustomTag('menu-projects')
class MenuProjects extends PolymerElement {
  MenuProjects.created() : super.created();

  @published List<Category> categories;
  @published String selectedSection;
}