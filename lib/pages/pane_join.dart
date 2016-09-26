@HtmlImport('pane_join.html')
library akepot.lib.pages.pane_join;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:app_router/app_router.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/iron_dropdown.dart';
import 'package:polymer_elements/iron_selector.dart';
import 'package:polymer_elements/neon_animated_pages.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

@PolymerRegister("pane-join")
class PaneJoin extends PolymerElement {
  @property String projectHash = "";
  String selected;
  List<String> multiselected;
  CompetencesService service;

  PaperButton joinButton;

  PaneJoin.created() : super.created();

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  @reflectable
  void signedIn(Event e, var detail){

    Person.exists(service.user.uid, projectHash, service, (exists) {
      if (exists){
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
      } else {
        newUser();
      }
    });

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = new Project.retrieve(projectHash, service);
  }

  void newUser(){
    joinButton = $$("#join-button");
    joinButton.disabled = false;
    joinButton.onClick.first.then(joinProject);
  }

  @reflectable
  void joinProject(Event e, var detail){
    if(selected == null || selected == ""){
      return;
    }
    if(multiselected == null || multiselected.isEmpty){
      return;
    }

    Person person = new Person.newRemote(service, service.user.uid, projectHash, nickName: service.user.nickname, emailAddress: service.user.email, firstName: service.user.firstname, lastName: service.user.lastname);
    for(String roleId in multiselected){
      person.assignRole(roleId);
    }
    service.project.teams.elementAt(int.parse(selected)).addPersonFull(person);
    //person.roles

    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }
}
