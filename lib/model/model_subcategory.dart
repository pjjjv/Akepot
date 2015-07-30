library akepot.model.model_subcategory;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_project.dart';
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

    _changeProperty("projects/$projectHash/subCategories/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("projects/$projectHash/subCategories/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<CompetenceTemplate> competenceTemplates = toObservable([]);
  @observable ObservableMap competenceTemplateIds = toObservable(new Map());

  @observable List<Competence> competences = toObservable([]);

  @observable CompetencesService service;

  SubCategory.full(this.id, String this.projectHash, this._name, this._description, this.competenceTemplates);

  SubCategory.newId(this.id, String this.projectHash);

  SubCategory.emptyDefault() {
    _name = "New Sub-Category";
  }

  factory SubCategory.retrieve(String id, String projectHash, CompetencesService service) {
    SubCategory subCategory = toObservable(new SubCategory.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/subCategories/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      subCategory.fromJson(val);

      if(subCategory != null) {
        subCategory._listen(projectHash, service);
      } else {
        //New subCategory
        subCategory = toObservable(new SubCategory.newRemote(projectHash, service));
      }
    });
    return subCategory;
  }

  factory SubCategory.newRemote(String projectHash, CompetencesService service) {
    SubCategory subCategory = toObservable(new SubCategory.emptyDefault());
    Firebase pushRef = service.dbRef.child("projects/$projectHash/subCategories").push();
    subCategory.id = pushRef.key;
    subCategory.projectHash = projectHash;
    pushRef.set(subCategory.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        subCategory._listen(projectHash, service);
      }
    });
    return subCategory;
  }

  toString() => name;

  addCompetenceTemplate(){
    CompetenceTemplate competenceTemplate = new CompetenceTemplate.newRemote(projectHash, service);
    service.dbRef.child("projects/$projectHash/subCategories/$id/competenceTemplateIds").update(new Map()..putIfAbsent(competenceTemplate.id, () => true));
  }

  removeCompetenceTemplate(int index){
    String competenceTemplateId = competenceTemplates[index].id;
    service.dbRef.child("projects/$projectHash/subCategories/$id/competenceTemplateIds/$competenceTemplateId").remove();
  }

  _listen(String projectHash, CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$projectHash/subCategories/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/subCategories/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    competenceTemplateIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            CompetenceTemplate competenceTemplate = new CompetenceTemplate.retrieve(record.key, projectHash, service);
            competenceTemplates.add(competenceTemplate);//TODO

            //Person's competence
            competences.add(new Competence.retrieveMatch(competenceTemplate.id, service.user.uid, service));
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

    service.dbRef.child("projects/$projectHash/subCategories/$id/competenceTemplateIds").onChildAdded.listen((e) {
      competenceTemplateIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$projectHash/subCategories/$id/competenceTemplateIds").onChildRemoved.listen((e) {
      competenceTemplateIds.remove(e.snapshot.key);
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    if (!_json.containsKey("projectHash") && noId == false) {
      throw new Exception("No projectHash.");
    }
    id = _json["id"]==null ? null : _json["id"];
    projectHash = _json["projectHash"]==null ? null : _json["projectHash"];
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
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
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