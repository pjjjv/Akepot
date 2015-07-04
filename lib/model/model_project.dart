library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';
import 'dart:convert';

/** Not documented yet. */
class Project extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/"+hash, new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String hash;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("projects/"+hash, new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Category> categories = toObservable([]);
  @observable ObservableMap categoryIds = toObservable(new Map());

  /** Not documented yet. */
  @observable List<String> teams = toObservable([]);

  /** Not documented yet. */
  String admin;

  @observable CompetencesService service;

  Project.full(this.hash, this._name, this._description, this.categories, this.teams, this.admin);

  Project.newHash(this.hash);

  Project.emptyDefault() {
    _name = "New Project";
  }

  factory Project.retrieve(String hash, CompetencesService service) {
    Project project = toObservable(new Project.newHash(hash));
    service.dbRef.child("projects/"+hash).once("value").then((snapshot) {
      Map val = snapshot.val();
      project.fromJson(val);

      if(project != null) {
        project._listen(service);
      } else {
        //New project
        project = toObservable(new Project.newRemote(service));
      }
    });
    return project;
  }

  factory Project.newRemote(CompetencesService service) {
    Project project = toObservable(new Project.emptyDefault());
    Firebase pushRef = service.dbRef.child("projects").push();
    project.hash = pushRef.key;
    pushRef.set(project.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        project._listen(service);
      }
    });
    return project;
  }

  toString() => name;

  addCategory(){
    Category category = new Category.newRemote(service);
    service.dbRef.child("projects/"+hash+"/categoryIds").update(new Map()..putIfAbsent(category.id, () => true));
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/"+hash+"/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("projects/"+hash+"/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    categoryIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't  need to do anything with PropertyChagneRecords.
        if (record is MapChangeRecord) {
          print(record);
          //Something added
          if (record.isInsert) {
            Category category = new Category.retrieve(record.key, service);
            categories.add(category);//TODO
          }

          //Something removed
          if (record.isRemove) {
            categories.removeWhere((category) => category.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/"+hash+"/categoryIds").onValue.listen((e) {
      Map map = e.snapshot.val();
      categoryIds.addAll(map);
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  fromJson(Map _json, [bool noHash = false]) {//TODO: use JsonObject: https://www.dartlang.org/articles/json-web-service/#introducing-jsonobject, or even better Dartson (see test-arrays-binding Firebase branch), when they work with polymer
    if (!_json.containsKey("hash") && noHash == false) {
      throw new Exception("No hash.");
    }
    hash = _json["hash"]==null ? null : _json["hash"];
    if (_json.containsKey("name")) {
      name = _json["name"];
    } else {
      name = "Unknown Project";
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    } else {
      description = "-";
    }
    /*if (_json.containsKey("categories")) {
      categories = toObservable(_json["categories"].map((value) => new Category.fromJson(value)).toList());
    }
    if (_json.containsKey("teams")) {
      teams = _toObservable(json["teams"]);
    }
    if (_json.containsKey("admin")) {
      admin = _json["admin"];
    }
     */
  }

  Map<String, dynamic> toJson() {
    var _json = new Map<String, dynamic>();
    if (description != null) {
      _json["description"] = description;
    }
    if (hash != null) {
      _json["hash"] = hash;
    }
    if (name != null) {
      _json["name"] = name;
    }
    /*if (categories != null) {
      _json["categories"] = categories.map((value) => (value).toJson()).toList();
    }
    if (teams != null) {
      _json["teams"] = teams;
    }
    if (admin != null) {
      _json["admin"] = admin;
    }*/
    return _json;
  }
}
