library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/competences_service.dart';

/** Not documented yet. */
class Project extends Observable {
  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String hash;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("project", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Category> categories = toObservable([]);

  @observable Map categoryIds;

  /** Not documented yet. */
  @observable List<String> teams = toObservable([]);

  /** Not documented yet. */
  String admin;

  @observable CompetencesService service;

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  Project.full(this.hash, this._name, this.description, this.categories, this.teams, this.admin);

  Project.newHash(this.hash);

  toString() => name;

  listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("project/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
  }

  factory Project.retrieve(String hash, CompetencesService service) {
    Project project = toObservable(new Project.newHash(hash));
    service.dbRef.child("project").once("value").then((snapshot) {
      Map val = snapshot.val();
      project.fromJson(val);

      if(project != null) {
        project.listen(service);
        print("listening1");
      } else {
        project = toObservable(new Project.newHash(hash));
        service.dbRef.child("project").update(project.toJson()).then((error) {
          if(error) {
            //
          } else {
            project.listen(service);
            print("listening2");
          }
        });
      }
    });
    return project;
  }

  fromJson(Map _json) {//TODO: use JsonObject: https://www.dartlang.org/articles/json-web-service/#introducing-jsonobject, or even better Dartson (see test-arrays-binding Firebase branch), when they work with polymer
    if (!_json.containsKey("hash")) {
      throw new Exception("No hash.");
    }
    hash = toObservable(_json["hash"]==null ? null : _json["hash"]);
    if (_json.containsKey("name")) {
      name = toObservable(_json["name"]);
    } else {
      name = toObservable("Project");
    }
    if (_json.containsKey("description")) {
      description = toObservable(_json["description"]);
    } else {
      description = toObservable("-");
    }
    if (_json.containsKey("categories")) {
      categories = toObservable(_json["categories"].map((value) => new Category.fromJson(value)).toList());
    }
    /*if (_json.containsKey("teams")) {
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
