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
  String _name = "New Project";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    changeProperty("project", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Category> categories = toObservable([]);

  @observable Map categoryIds;

  /** Not documented yet. */
  @observable List<String> teams = toObservable([]);

  /** Not documented yet. */
  String admin;

  @observable CompetencesService service;

  changeProperty(String child, var value){
    service.dbRef.child(child).update(value);
  }

  Project(this.hash, this._name, this.description, this.categories, this.teams, this.admin, this.service);

  Project.create(hash) : hash = hash, name = "New Project", description = "", categories = toObservable([]), teams = toObservable([]), admin = null;

  Project.empty(this.hash);

  toString() => name;

  factory Project.fromJson(Map _json, CompetencesService service) {//TODO: use JsonObject: https://www.dartlang.org/articles/json-web-service/#introducing-jsonobject, or even better Dartson (see test-arrays-binding Firebase branch), when they work with polymer
    String hash = "";
    String name = "Project";
    String description = "-";
    List<Category> categories = toObservable([]);
    List<String> teams = toObservable([]);
    String admin = "";

    if (!_json.containsKey("hash")) {
      throw new Exception("No hash.");
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
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

    Project project = new Project((_json["hash"]==null ? null : _json["hash"]),
        name, description, categories, teams, admin, service);
    return project;
  }

  Map toJson() {
    var _json = new Map();
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

  void categoriesToJson() {
    categoriesAsJson = JSON.encode(categories);
  }

  void categoriesFromJson() {
    categories = toObservable(JSON.decode(categoriesAsJson.trim().replaceAll("\n", " ")).map((value) => new Category.fromJson(value, true)).toList());
  }

  void teamsToJson() {
    teamsAsJson = JSON.encode(teams);
  }

  void teamsFromJson() {
    teams = toObservable(JSON.decode(teamsAsJson.trim().replaceAll("\n", " ")));
  }


}
