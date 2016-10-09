@HtmlImport('panes_category.html')
library akepot.lib.pages.panes_category;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/pages/pane_category.dart';
import 'package:akepot/competences_service.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/neon_animated_pages.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'dart:developer';

@PolymerRegister('panes-category')
class PanesCategory extends PolymerElement {

  CompetencesService service;
  @property String projectHash = "";
  @property String selectedCategory = "";//Bugfix: needs to be assigned "", to prevent it from being 0.

  @Property(notify: true, observer: 'selectedChanged') bool selected;
  bool signInDone = false;

  PanesCategory.created() : super.created();

  void attached(){
    async(() {
      service = new IronMeta().byKey('service');

      if(service.signedIn) signedIn(null, null);
    });
  }

  @reflectable
  void selectedChanged(bool selected, bool old) {
    debugger();
    if(signInDone && selected==true && old==false){
      start();
    }
  }

  @reflectable
  void signedIn(Event e, var detail){
    debugger();
    signInDone = true;
    if(selected){
      start();
    }
  }

  void start(){
    debugger();
    Person.exists(service.user.uid, projectHash, service, (exists) {
      if (!exists){
        new AppLocation().path = "/project/$projectHash/join";
      }
    });

    if(service.project != null && service.project.hash == projectHash){
      return;
    } else {
      if(selectedCategory != "" && selectedCategory != null){
        //If we come in through a direct category link, then go back to main project page (no category).
        //Bugfix: We do this to avoid a bug, where core-selector (extended by core-animated-pages) is unable to deal with changing content. We would have to set selected again after everything is loaded from firebase, but we don't know when that is.
        new AppLocation().path = "/project/$projectHash";
      }
    }

    service.project = new Project.retrieve(projectHash, service);
  }
}
