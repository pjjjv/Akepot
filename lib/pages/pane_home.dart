import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:js';

@CustomTag("pane-home")
class PaneHome extends PolymerElement {
  PaneHome.created() : super.created();

  PaperButton newButton;

  @published Project project;
  @published String generatedHash = null;

  void domReady(){

    newButton = shadowRoot.querySelector("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(newProject);
  }

  void newProject(Event e){
    String message = context['MoreRouting'].callMethod('urlFor', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
    print("New admin link would be: $message");
    context['MoreRouting'].callMethod('navigateTo', ['adminRoute', new JsObject.jsify({'projectHash': '$generatedHash'})]);
  }
}