
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';

@CustomTag("pane-input")
class PaneInput extends PolymerElement {
  PaneInput.created() : super.created();

  @published Project project;
}