@HtmlImport('pane_home.html')
library akepot.lib.pages.pane_home;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:polymer_elements/paper_button.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_team.dart';
import 'package:akepot/competences_service.dart';

@PolymerRegister("pane-home")
class PaneHome extends PolymerElement {
  PaneHome.created() : super.created();

  PaperButton newButton;
  CompetencesService service;

  void domReady(){
    service = document.querySelector("#service");

    newButton = $$("#new-button");
    newButton.hidden = false;
    newButton.onClick.listen(newProject);
  }

  void newProject(Event e){
    service.project = new Project.newRemote(service);

    Person.exists(service.user.uid, service.project.hash, service, (exists) {
      if (exists){
        //(document.querySelector('app-router') as AppRouter).go("/project/${service.project.hash}");//TODO
      } else {
        Team team = service.project.addTeam();
        team.service = service;

        Person person = new Person.newRemote(service, service.user.uid, service.project.hash, nickName: service.user.nickname, emailAddress: service.user.email, firstName: service.user.firstname, lastName: service.user.lastname, admin: true);
        person.setAdmin(true, service.project);
        team.addPersonFull(person);
      }
    });

    //(document.querySelector('app-router') as AppRouter).go("/admin/${service.project.hash}/edit");
  }
}