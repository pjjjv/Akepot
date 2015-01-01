library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'dart:convert';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_competence.dart';


/** Not documented yet. */
class Project extends ChangeNotifier {
  /** Not documented yet. */
  @reflectable @observable Text get description => __$description; Text __$description = new Text(""); @reflectable set description(Text value) { __$description = notifyPropertyChange(#description, __$description, value); }

  /** Not documented yet. */
  core.Map id;

  /** Not documented yet. */
  @reflectable @observable core.String get hash => __$hash; core.String __$hash; @reflectable set hash(core.String value) { __$hash = notifyPropertyChange(#hash, __$hash, value); }

  /** Not documented yet. */
  @reflectable @observable core.String get name => __$name; core.String __$name = "New Project"; @reflectable set name(core.String value) { __$name = notifyPropertyChange(#name, __$name, value); }

  /** Not documented yet. */
  core.List<Category> categories;

  @reflectable @observable core.String get categoriesAsJson => __$categoriesAsJson; core.String __$categoriesAsJson = ""; @reflectable set categoriesAsJson(core.String value) { __$categoriesAsJson = notifyPropertyChange(#categoriesAsJson, __$categoriesAsJson, value); }

  /** Not documented yet. */
  @reflectable @observable core.List<core.String> get teams => __$teams; core.List<core.String> __$teams; @reflectable set teams(core.List<core.String> value) { __$teams = notifyPropertyChange(#teams, __$teams, value); }

  /** Not documented yet. */
  @reflectable @observable core.String get teamsAsJson => __$teamsAsJson; core.String __$teamsAsJson = ""; @reflectable set teamsAsJson(core.String value) { __$teamsAsJson = notifyPropertyChange(#teamsAsJson, __$teamsAsJson, value); }

  Project(this.id, hash, name, description, this.categories, teams) : __$hash = hash, __$name = name, __$description = description, __$teams = teams;

  Project.empty(hash) : __$hash = hash;

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
