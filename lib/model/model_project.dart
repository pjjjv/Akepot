library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'dart:convert';
import 'package:akepot/model/model_category.dart';


/** Not documented yet. */
class Project extends Observable {
  /** Not documented yet. */
  @observable core.String description = "";

  /** Not documented yet. */
  @observable core.String hash;

  /** Not documented yet. */
  @observable core.String name = "New Project";

  /** Not documented yet. */
  @observable core.List<Category> categories = toObservable([]);

  @observable core.String categoriesAsJson = "";

  /** Not documented yet. */
  @observable core.List<core.String> teams = toObservable([]);

  /** Not documented yet. */
  @observable core.String teamsAsJson = "";

  /** Not documented yet. */
  core.String admin;

  @observable core.String adminAsJson = "";

  Project(this.hash, this.name, this.description, this.categories, this.teams, this.admin);

  Project.create(hash) : hash = hash, name = "New Project", description = "", categories = toObservable([]), teams = toObservable([]), admin = null;

  Project.empty(this.hash);

  toString() => name;

  factory Project.fromJson(core.Map _json) {
    core.String hash = "";
    core.String name = "Project";
    core.String description = "-";
    core.List<Category> categories = toObservable([]);
    core.List<core.String> teams = toObservable([]);
    core.String admin = "";

    if (!_json.containsKey("hash")) {
      throw new core.Exception("No hash.");
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

    Project project = new Project((_json["hash"]==null ? null : core.String.parse(_json["hash"])),
        name, description, categories, teams, admin);
    return project;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = description;
    }
    if (hash != null) {
      _json["hash"] = hash;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (categories != null) {
      _json["categories"] = categories.map((value) => (value).toJson()).toList();
    }
    if (teams != null) {
      _json["teams"] = teams;
    }
    if (admin != null) {
      _json["admin"] = admin;
    }
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
