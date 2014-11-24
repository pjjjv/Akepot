import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';

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
  @observable List items = toObservable([]);
  @observable var orderedIndex = "content1";

  void goTo(Event e) {
    print("wentTo");
  }
}