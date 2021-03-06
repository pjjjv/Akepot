
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';
import 'package:paper_elements/paper_button.dart';

@CustomTag("pane-join")
class PaneJoin extends PolymerElement {
  @published String projectHash = "";
  @observable String selected;
  @observable List<String> multiselected;
  @observable CompetencesService service;

  PaperButton joinButton;

  PaneJoin.created() : super.created();

  domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){

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
    joinButton = shadowRoot.querySelector("#join-button");
    joinButton.disabled = false;
    joinButton.onClick.first.then(joinProject);
  }

  void joinProject(Event e){
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