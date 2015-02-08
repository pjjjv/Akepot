
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
//import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';

@CustomTag("pane-input")
class PaneInput extends PolymerElement {
  PaneInput.created() : super.created();

  Project project;
  PaperButton createButton;

  @published AppRouter router;
  @published String projectHash = "";
  @observable String newlink;

  void domReady() {
    createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);
  }

  void createProject(Event e){
    print ("createProject");
    project = router.templateInstance.model.project;
    project.categoriesFromJson();
    project.teamsFromJson();
    router.templateInstance.model.service.newProject(project, projectHash);
  }
}