library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'dart:convert';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_competence.dart';


/** Not documented yet. */
class Project extends Observable {
  /** Not documented yet. */
  @observable Text description = new Text("");

  /** Not documented yet. */
  core.Map id;

  /** Not documented yet. */
  @observable core.String hash;

  /** Not documented yet. */
  @observable core.String name = "New Project";

  /** Not documented yet. */
  core.List<Category> categories;

  @observable core.String categoriesAsJson = "";

  /** Not documented yet. */
  @observable core.List<core.String> teams;

  /** Not documented yet. */
  @observable core.String teamsAsJson = "";

  Project(this.id, this.hash, this.name, this.description, this.categories, this.teams);

  Project.empty(this.hash);

  toString() => name;

  factory Project.fromJson(core.Map _json) {
    core.String hash = "";
    core.String name = "Project";
    Text description = new Text("-");
    core.List<Category> categories = [];
    core.List<core.String> teams = [];

    if (!_json.containsKey("id")) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("hash")) {
      hash = _json["hash"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = new Text.fromJson(_json["description"]);
    }
    if (_json.containsKey("categories")) {
      categories = _json["categories"].map((value) => new Category.fromJson(value)).toList();
    }
    /*if (_json.containsKey("teams")) {
      teams = _json["teams"];
    }*/

    Project project = new Project(_json["id"], hash, name, description,
        categories, teams);
    return project;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = (description).toJson();
    }
    if (id != null) {
      _json["id"] = id;
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
    return _json;
  }

  void categoriesToJson() {
    categoriesAsJson = JSON.encode(categories);
  }

  void categoriesFromJson() {
    categories = JSON.decode(categoriesAsJson.trim().replaceAll("\n", " ")).map((value) => new Category.fromJson(value, true)).toList();
  }

  void teamsToJson() {
    teamsAsJson = JSON.encode(teams);
  }

  void teamsFromJson() {
    teams = JSON.decode(teamsAsJson.trim().replaceAll("\n", " "));
  }
}
