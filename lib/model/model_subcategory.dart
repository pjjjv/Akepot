library akepot.model.model_subcategory;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class SubCategory extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("subCategories/"+id, new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("subCategories/"+id, new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Competence> competences = toObservable([]);
  @observable ObservableMap competenceIds = toObservable(new Map());

  @observable CompetencesService service;

  SubCategory.full(this.id, this._name, this._description, this.competences);

  SubCategory.newId(this.id);

  SubCategory.emptyDefault() {
    _name = "New Sub-Category";
  }

  factory SubCategory.retrieve(String id, CompetencesService service) {
    SubCategory subCategory = toObservable(new SubCategory.newId(id));
    service.dbRef.child("subCategories/"+id).once("value").then((snapshot) {
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

  addCompetence(){
    Competence competence = new Competence.newRemote(service);
    service.dbRef.child("subCategories/"+id+"/competenceIds").update(new Map()..putIfAbsent(competence.id, () => true));
  }

  removeCompetence(int index){
    String competenceId = competences[index].id;
    service.dbRef.child("subCategories/"+id+"/competenceIds/"+competenceId).remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("subCategories/"+id+"/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("subCategories/"+id+"/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    competenceIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Competence competence = new Competence.retrieve(record.key, service);
            competences.add(competence);//TODO
          }

          //Something removed
          if (record.isRemove) {
            competences.removeWhere((competence) => competence.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("subCategories/"+id+"/competenceIds").onChildAdded.listen((e) {
      competenceIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("subCategories/"+id+"/competenceIds").onChildRemoved.listen((e) {
      print("prevChild: "+e.snapshot.key);
      competenceIds.remove(e.snapshot.key);
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