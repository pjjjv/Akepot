
import 'package:polymer/polymer.dart';

@CustomTag('items-list')
class ItemsList extends PolymerElement {
  ItemsList.created() : super.created();

  @observable List competences = null;
}