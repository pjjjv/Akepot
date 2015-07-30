import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_team.dart';
import 'package:app_router/app_router.dart';
import 'package:akepot/competences_service.dart';

@CustomTag("pane-home")
class PaneHome extends PolymerElement {
  PaneHome.created() : super.created();

  PaperButton newButton;
  Project project;
  CompetencesService service;

  void domReady(){
    service = document.querySelector("#service");

    newButton = shadowRoot.querySelector("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(newProject);
  }

  void newProject(Event e){
    Project project = new Project.newRemote(service);

    Person.exists(service.user.uid, project.hash, service, (exists) {
      if (exists){
        (document.querySelector('app-router') as AppRouter).go("/project/${project.hash}");//TODO
      } else {
        Team team = project.addTeam();
        team.service = service;

        Person person = new Person.newRemote(service, service.user.uid, project.hash, nickName: service.user.nickname, emailAddress: service.user.email, firstName: service.user.firstname, lastName: service.user.lastname, admin: true);
        person.setAdmin(true, project);
        team.addPersonFull(person);
      }
    });

    (document.querySelector('app-router') as AppRouter).go("/admin/${project.hash}/edit");
  }
}