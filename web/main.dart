import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import 'package:akepot/model/model_category.dart';

void main() {
  initPolymer().run(() {
    //(querySelector('#menu_button') as PolymerElement).onClick.listen(openMenu);
    Content contentModel;


    Polymer.onReady.then((_) {
      var content = document.querySelector('#content');
      contentModel = new Content();
      templateBind(content).model = contentModel;
    });
  });
}

void openMenu(Event e) {
  print("openMenu");
  var dialog = querySelector('#dialog');
  dialog.toggle();
}

class Content extends Observable {
  @observable List competences = toObservable([]);
  @observable var orderedIndex = "c1";//TODO
  @observable var projectsRoute;

  @observable List<Category> categories = [];

  void goTo(Event e) {
    print("wentTo");
  }

}