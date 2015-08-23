
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_team.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_role.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_competencelevel.dart';
import 'package:akepot/model/model_competencetemplate.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'dart:html';
import 'dart:async';
import 'package:akepot/competences_service.dart';


class Header extends Observable {
  @observable String label = "";
  @observable Person person;
  @observable Role role;
}

class Row extends Observable {
  @observable String label = "";
  @observable ObservableList<Item> items = toObservable([]);
  @observable CompetenceTemplate template;

  List<Item> get levelItems {
    List<Item> results = toObservable([]);
    for(Item item in items.where((Item item) => item.level != null)){
      results.add(item);
    }
    return results;
  }

  List<Item> get competenceItems {
    List<Item> results = toObservable([]);
    for(Item item in items.where((Item item) => item.competence != null)){
      results.add(item);
    }
    return results;
  }

  asInt(String str) => int.parse(str);
}

class Item extends Observable {
  @observable Competence competence;
  @observable CompetenceLevel level;
  @observable String type;

  @observable String get value {
    if(competence != null){
      return competence.rating.toString();
    } else if (level != null){
      return level.level.toString();
    }
    return 0.toString();
  }
  @observable void set value(String value) {
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

  @observable List<CompetenceLevel> thresholdLevels;
  @observable int threshold = 0;

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

@CustomTag("pane-report")
class PaneReport extends PolymerElement {
  PaneReport.created() : super.created() {
  }

  @observable CompetencesService service;
  @published String projectHash = "";
  @observable bool locallySignedIn = false;

  @observable ObservableList<Header> headers = toObservable([]);
  @observable ObservableList<Row> rows = toObservable([]);


  void domReady() {
    service = document.querySelector("#service");

    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = toObservable(new Project.retrieve(projectHash, service));

    const twenty = const Duration(seconds:5);
    new Timer(twenty, fillTable);
  }

  void fillTable(){

    //Column Headers
    headers = toObservable([]);
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
    rows = toObservable([]);
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
          item.thresholdLevels = toObservable([]);

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