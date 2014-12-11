import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_style.dart';
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

      setAkepotTransitionSpeed(350);
    });
  });
}

void openMenu(Event e) {
  print("openMenu");
  var dialog = querySelector('#dialog');
  dialog.toggle();
}

class Content extends Observable {
  //@observable List competences = toObservable([]);
  @observable var projectRoute;
  @observable var adminRoute;

  @observable List<Category> categories = [];

  @observable String selectedCategory = "splash";

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  Content () {
    startup();
  }

  void startup () {
    print(SPLASH_TIMEOUT);
    new Timer(SPLASH_TIMEOUT, completeStartup);
  }

  void completeStartup () {
    if(categories.isEmpty == true){
      startup();
      return;
    }
    selectedCategory = "Technical Competence";//TODO
  }

  void goTo(Event e) {
    print("wentTo");
  }

}

void setAkepotTransitionSpeed(int timeInMs){
  /*CoreStyle.g.transitions.duration = timeInMs + 'ms';
  CoreStyle.g.transitions.scaleDelay = CoreStyle.g.transitions.duration;*/
}
