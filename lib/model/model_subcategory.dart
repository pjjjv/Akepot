library akepot.model.model_subcategory;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_competencetemplate.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class SubCategory extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("subCategories/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("subCategories/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<CompetenceTemplate> competenceTemplates = toObservable([]);
  @observable ObservableMap competenceTemplateIds = toObservable(new Map());

  @observable List<Competence> competences = toObservable([]);

  @observable CompetencesService service;

  SubCategory.full(this.id, this._name, this._description, this.competenceTemplates);

  SubCategory.newId(this.id);

  SubCategory.emptyDefault() {
    _name = "New Sub-Category";
  }

  factory SubCategory.retrieve(String id, CompetencesService service) {
    SubCategory subCategory = toObservable(new SubCategory.newId(id));
    service.dbRef.child("subCategories/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      subCategory.fromJson(val);

      if(subCategory != null) {
        subCategory._listen(service);
      } else {
        //New subCategory
        subCategory = toObservable(new SubCategory.newRemote(service));
      }
    });
    return subCategory;
  }

  factory SubCategory.newRemote(CompetencesService service) {
    SubCategory subCategory = toObservable(new SubCategory.emptyDefault());
    Firebase pushRef = service.dbRef.child("subCategories").push();
    subCategory.id = pushRef.key;
    pushRef.set(subCategory.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        subCategory._listen(service);
      }
    });
    return subCategory;
  }

  toString() => name;

  addCompetenceTemplate(){
    CompetenceTemplate competenceTemplate = new CompetenceTemplate.newRemote(service);
    service.dbRef.child("subCategories/$id/competenceTemplateIds").update(new Map()..putIfAbsent(competenceTemplate.id, () => true));
  }

  removeCompetenceTemplate(int index){
    String competenceTemplateId = competenceTemplates[index].id;
    service.dbRef.child("subCategories/$id/competenceTemplateIds/$competenceTemplateId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("subCategories/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("subCategories/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    competenceTemplateIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            CompetenceTemplate competenceTemplate = new CompetenceTemplate.retrieve(record.key, service);
            competenceTemplates.add(competenceTemplate);//TODO

            //Person's competence
            competences.add(findOrCreatePersonCompetence(competenceTemplate));
          }

          //Something removed
          if (record.isRemove) {
            competenceTemplates.removeWhere((competenceTemplate) => competenceTemplate.id == record.key);

            //Person's competence
            competences.removeWhere((competence) => competence.competenceTemplateId == record.key);
          }
        }
      }
    });

    service.dbRef.child("subCategories/$id/competenceTemplateIds").onChildAdded.listen((e) {
      competenceTemplateIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("subCategories/$id/competenceTemplateIds").onChildRemoved.listen((e) {
      competenceTemplateIds.remove(e.snapshot.key);
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  Competence findOrCreatePersonCompetence(CompetenceTemplate competenceTemplate){
    Competence competence = new Competence.emptyDefault();
    new Person.retrieve(service.user.uid, service, (Person person) {
      competence = person.competences.firstWhere(
          (competence) => competence.competenceTemplateId == competenceTemplate.id,
          orElse: () => _createCopyPersonCompetence(competenceTemplate, person));
    });
    return competence;
  }

  Competence _createCopyPersonCompetence(CompetenceTemplate competenceTemplate, Person person){
    return person.addCompetence(competenceTemplate);
  }

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    id = _json["id"]==null ? null : _json["id"];
    if (_json.containsKey("name")) {
      name = _json["name"];
    } else {
      name = "Unknown Sub-Category";
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    } else {
      description = "-";
    }
    /*if (_json.containsKey("competences")) {
      competences = toObservable(_json["competences"].map((value) => new Competence.fromJson(value, noId)).toList());
    }*/
  }

  Map<String, dynamic> toJson() {
    var _json = new Map<String, dynamic>();
    if (description != null) {
      _json["description"] = description;
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (name != null) {
      _json["name"] = name;
    }
    /*if (competences != null) {
      _json["competences"] = competences.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}