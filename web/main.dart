import 'dart:html';
import 'package:polymer/polymer.dart';

void main() {
  initPolymer().run(() {
    // The rest of the code in the main method.
    querySelector('#menu_button').on['tap'].listen(openMenu);
  });
}

void openMenu(Event e) {
  print("openMenu");
  var dialog = querySelector('#dialog');
  dialog.toggle();
}