
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';

@CustomTag("edit-category")
class EditCategory extends PolymerElement {
  EditCategory.created() : super.created() {
    if (form) {
      category = new Category();
    }
  }

  @published Category category;
  @observable bool selected;
  @published bool form = false;

}