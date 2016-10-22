@HtmlImport('pane_join.html')
library akepot.lib.pages.pane_join;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/iron_dropdown.dart';
import 'package:polymer_elements/iron_selector.dart';
import 'package:polymer_elements/neon_animated_pages.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'dart:developer';

@PolymerRegister("pane-join")
class PaneJoin extends PolymerElement {
  @property String projectHash = "";
  String selected;
  List<String> multiselected;
  CompetencesService service;

  PaperButton joinButton;

  @Property(notify: true, observer: 'selectedChanged') bool selected2;
  bool signInDone = false;

  PaneJoin.created() : super.created();

  attached(){
    async(() {
      service = new IronMeta().byKey('service');

      if(service.signedIn) signedIn(null, null);
    });
  }

  @reflectable
  void selectedChanged(bool selected2, bool old) {
    debugger();
    if(signInDone && selected2==true && (old==false || old==null)){
      start();
    }
  }

  @reflectable
  void signedIn(Event e, var detail){
    debugger();
    signInDone = true;
    if(selected2){
      start();
    }
  }

  void start(){
    debugger();
    Person.exists(service.user.uid, projectHash, service, (exists) {
      if (exists){
        new AppLocation().path = "/project/$projectHash";
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

    new AppLocation().path = "/project/$projectHash";
  }
}
