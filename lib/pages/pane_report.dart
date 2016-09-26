@HtmlImport('pane_report.html')
library akepot.lib.pages.pane_report;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_team.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_role.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_competencelevel.dart';
import 'package:akepot/model/model_competencetemplate.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/strength_button.dart';
import 'dart:html';
import 'dart:async';
import 'package:akepot/competences_service.dart';
import 'package:observe/observe.dart' as observe;
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/neon_animated_pages.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';

class Header extends observe.Observable {
  @observe.observable String label = "";
  @observe.observable Person person;
  @observe.observable Role role;
}

class Row extends observe.Observable {
  @observe.observable String label = "";
  @observe.observable observe.ObservableList<Item> items = observe.toObservable([]);
  @observe.observable CompetenceTemplate template;

  List<Item> get levelItems {
    List<Item> results = observe.toObservable([]);
    for(Item item in items.where((Item item) => item.level != null)){
      results.add(item);
    }
    return results;
  }

  List<Item> get competenceItems {
    List<Item> results = observe.toObservable([]);
    for(Item item in items.where((Item item) => item.competence != null)){
      results.add(item);
    }
    return results;
  }

  asInt(String str) => int.parse(str);
}

class Item extends observe.Observable {
  @observe.observable Competence competence;
  @observe.observable CompetenceLevel level;
  @observe.observable String type;

  @observe.observable String get value {
    if(competence != null){
      return competence.rating.toString();
    } else if (level != null){
      return level.level.toString();
    }
    return 0.toString();
  }
  @observe.observable void set value(String value) {
    if(competence != null){
      try{
        competence.rating = int.parse(value);
      } on FormatException catch(e) {

      }
    } else if (level != null){
      try{
        level.level = int.parse(value);
      } on FormatException catch(e) {

      }
    }
  }

  @observe.observable List<CompetenceLevel> thresholdLevels;
  @observe.observable int threshold = 0;

  void calculateThreshold([String roleId, int newLevel]){
    int minimum = 0;
    for (CompetenceLevel competence in thresholdLevels){
      int level = competence.level;
      if(roleId!=null && roleId == competence.rid){
        level = newLevel;
      }
      if(level>minimum){
        minimum=level;
      }
    }
    threshold = minimum;
  }
}

@PolymerRegister("pane-report")
class PaneReport extends PolymerElement {
  PaneReport.created() : super.created() {
  }

  @observe.observable CompetencesService service;
  @property String projectHash = "";
  @observe.observable bool locallySignedIn = false;

  @observe.observable observe.ObservableList<Header> headers = observe.toObservable([]);
  @observe.observable observe.ObservableList<Row> rows = observe.toObservable([]);


  void ready() {
    service = document.querySelector("#service");

    if(service.signedIn) signedIn(null, null, null);
  }

  @reflectable
  void signedIn(Event e, var detail){

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = observe.toObservable(new Project.retrieve(projectHash, service));

    const twenty = const Duration(seconds:5);
    new Timer(twenty, fillTable);
  }

  void fillTable(){

    //Column Headers
    headers = observe.toObservable([]);
    for (Role role in service.project.roles){
      Header header = new Header();
      header.role = role;
      header.label = role.name;
      headers.add(header);
    }
    for (Team team in service.project.teams){
      for (Person person in team.persons){
        Header header = new Header();
        header.person = person;
        header.label = person.nickName;
        headers.add(header);
      }
    }


    //Row Headers
    rows = observe.toObservable([]);
    for (Category category in service.project.categories){
      for (SubCategory subCategory in category.subcategories){
        for(CompetenceTemplate competenceTemplate in subCategory.competenceTemplates){
          Row row = new Row();
          row.template = competenceTemplate;
          row.label = competenceTemplate.label;
          rows.add(row);
        }
      }
    }



    //Contents
    for(Row row in rows){
      for(Header header in headers){
        if(header.role != null){
          Item item = new Item();
          item.type = 'edit';
          item.level = new CompetenceLevel.retrieveMatch(projectHash, header.role.id, row.template.id, service);
          row.items.add(item);
        } else if (header.person != null){
          Item item = new Item();
          item.type = 'strength';
          item.competence = new Competence.retrieveMatch(projectHash, header.person.id, row.template.id, service);
          item.thresholdLevels = observe.toObservable([]);

          for(int i = 0; i<headers.length; i++){
            Header roleHeader = headers[i];
            if(roleHeader.role==null) continue;
            if(header.person.roleIds.containsKey(roleHeader.role.id)){
              item.thresholdLevels.add(row.items[i].level);
            }
          }
          row.items.add(item);
        }
      }
    }

    const twenty = const Duration(seconds:5);
    new Timer(twenty, fillTable2);

  }

  void fillTable2(){

    //Contents
    for(Row row in rows){
      for(Item item in row.competenceItems){
        for(Item levelItem in row.levelItems){
          levelItem.level.addLevelChangeListener(service, (e) {
            item.calculateThreshold(levelItem.level.rid, e.snapshot.val());
          });
        }
        item.calculateThreshold();
      }
    }

    locallySignedIn = true;
  }
}
