
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:paper_elements/paper_button.dart';
import 'package:akepot/competences_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:app_router/app_router.dart';
import 'package:core_elements/core_ajax_dart.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag("pane-input")
class PaneInput extends PolymerElement {
  PaneInput.created() : super.created() {
    startupForAdmin(true);
  }

  @observable Project project;
  PaperButton createButton;

  CompetencesService service;
  @published String projectHash = "";
  @observable String newlink;

  CoreAjax ajaxNewProject;
  CoreAjax ajaxNewPerson;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void domReady() {
    service = document.querySelector("#service");
    ajaxNewProject = shadowRoot.querySelector('#ajaxNewProject');
    ajaxNewPerson = shadowRoot.querySelector('#ajaxNewPerson');
    createButton = shadowRoot.querySelector("#create-button");
    createButton.hidden = false;
    createButton.onClick.listen(createProject);
  }

  void createProject(Event e){
    print ("createProject");
    project.categoriesFromJson();
    project.teamsFromJson();
    newProject(project, projectHash);
  }


  void startupForAdmin (bool first) {
    print(SPLASH_TIMEOUT);
    if(first){
      project = new Project.empty(projectHash);

      HttpRequest.getString("data/fresh_categories.json")
      .then((String text) => project.categoriesAsJson = text)
      .catchError((Error error) => print("Error: $error"));

      HttpRequest.getString("data/fresh_teams.json")
      .then((String text) => project.teamsAsJson = text)
      .catchError((Error error) => print("Error: $error"));
    }
    new Timer(SPLASH_TIMEOUT, completeStartupForAdmin);

  }

  void completeStartupForAdmin () {
    if(service == null || !service.signedin){
      startupForAdmin(false);
      return;
    }
  }






  void newProject(Project project, String thishash){
    if(service == null || !service.signedin){
      throw new Exception("Not signed in.");
    }
    ajaxNewProject.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/project/$thishash";
    if(document.querySelector("#cmdebug") != null){
      ajaxNewProject.method = "GET";
      ajaxNewProject.url = "data/new_project_response.json";
    }
    ajaxNewProject.body = JSON.encode(project.toJson());
    print("url: ${ajaxNewProject.url}, body: ${ajaxNewProject.body}");
    ajaxNewProject.onCoreResponse.first.then(ajaxNewProjectResponse);
    ajaxNewProject.go();
  }

  void addAdminPerson(String teamId){
    if(service == null || !service.signedin){
      throw new Exception("Not signed in.");
    }
    Map map = {};
    map['nickName'] = service.user.nickname;
    map['firstName'] = service.user.firstname;
    map['lastName'] = service.user.lastname;
    map['emailAddress'] = {};
    map['emailAddress']['email'] = service.user.email;
    map['token'] = service.user.userid;

    ajaxNewPerson.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/addUser/$projectHash/$teamId";
    if(document.querySelector("#cmdebug") != null){
      ajaxNewPerson.method = "GET";
      ajaxNewPerson.url = "data/add_admin_person_response.json";
    }
    ajaxNewPerson.body = JSON.encode(map);
    print("url: ${ajaxNewPerson.url}, body: ${ajaxNewPerson.body}");
    ajaxNewPerson.onCoreResponse.first.then(ajaxAddAdminPersonResponse);
    ajaxNewPerson.go();
  }

  @reflectable
  void ajaxNewProjectResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxNewProjectResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    String teamId = response['teams'][0]['id']['id'];

    addAdminPerson(teamId);
  }

  @reflectable
  void ajaxAddAdminPersonResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxAddAdminPersonResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + "#/project/"; //+ projectHash;
    print("New project link would be: $newlink");


    PaperActionDialog dialog = shadowRoot.querySelector('#created-dialog');

    PaperButton goButton = shadowRoot.querySelector('#go-button');
    goButton.onClick.first.then(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    (document.querySelector('app-router') as AppRouter).go("/project/$projectHash");
  }
}