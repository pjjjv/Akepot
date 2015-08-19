
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

@CustomTag("pane-report")
class PaneReport extends PolymerElement {
  PaneReport.created() : super.created() {
  }

  @observable CompetencesService service;
  @published String projectHash = "";
  @observable bool locallySignedIn = false;

  //@observable ObservableList<ObservableMap> tableData = toObservable([]);

@observable var tableData = toObservable([
{'first': true, 'second': 'opt1', 'third': 'one'},
{'first': false, 'second': 'opt2', 'third': 'two'},
{'first': true, 'second': 'opt1', 'third': 'three'},
{'first': true, 'second': 'opt1', 'third': 'four'},
{'first': false, 'second': 'opt2', 'third': 'five'},
{'first': true, 'second': 'opt1', 'third': 'six'},
{'first': true, 'second': 'opt1', 'third': 'seven'},
{'first': false, 'second': 'opt2', 'third': 'eight'},
{'first': true, 'second': 'opt1', 'third': 'nine'}
]);

  void domReady() {
    service = document.querySelector("#service");

    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = toObservable(new Project.retrieve(projectHash, service));

    //const twenty = const Duration(seconds:5);
    //new Timer(twenty, fillTable);
  }

  @observable List<Person> persons;
  @observable List<Role> roles;

  void fillTable(){

    persons = toObservable([]);
    for (Team team in service.project.teams){
      persons.addAll(team.persons);
    }
    roles = toObservable(service.project.roles);

    /*for (Role role in persons){
      for (Category category in service.project.categories){
        for (SubCategory subCategory in category.subcategories){
          subCategory.competenceTemplateIds.changes.listen((records) {
            for (ChangeRecord record in records) {
              //We don't need to do anything with PropertyChangeRecords.
              if (record is MapChangeRecord) {
                //Something added
                if (record.isInsert) {
                  //Role's competence level
                  competenceLevels.add(new CompetenceLevel.retrieveMatch(projectHash, service.user.uid, record.key, service));
                }

                //Something removed
                if (record.isRemove) {
                  //Role's competence level
                  competenceLevels.removeWhere((competenceLevel) => competenceLevel.tid == record.key);
                }
              }
            }
          });
        }
      }
    }*/

    for (Person person in persons){
      for (Category category in service.project.categories){
        for (SubCategory subCategory in category.subcategories){
          for(CompetenceTemplate competenceTemplate in subCategory.competenceTemplates){
            //Person's competence
            person.allCompetences.add(new Competence.retrieveMatch(projectHash, person.id, competenceTemplate.id, service));
          }
        }
      }
    }

    const twenty = const Duration(seconds:5);
    new Timer(twenty, fillTable2);

  }

  void fillTable2(){

    for(var c = 0; c < persons[0].allCompetences.length; c++) {
      ObservableMap map = toObservable({});
      for(Role role in roles){
        map.putIfAbsent(role.id, () => 0);
      }
      for(Person person in persons){
        map.putIfAbsent(person.id, () => person.allCompetences[c].rating);
      }
      tableData.add(map);
    }

    print("tableData"+tableData.toString());
    locallySignedIn = true;
  }

}