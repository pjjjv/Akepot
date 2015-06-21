library akepot.model.model_subcategory;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/model/model_competence.dart';

/** Not documented yet. */
class SubCategory extends Observable {
  /** Not documented yet. */
  final core.String description;

  /** Not documented yet. */
  final core.int id;

  /** Not documented yet. */
  final core.List<Competence> competences;

  /** Not documented yet. */
  final core.String name;

  SubCategory(this.id, this.name, this.description, this.competences);
  SubCategory.create() : id = null, name = "New", description = "", competences = [];

  toString() => name;

  factory SubCategory.fromJson(core.Map _json, [core.bool noId = false]) {
    core.String name = "SubCategory";
    core.String description = "-";
    core.List<Competence> competences = [];

    if (!_json.containsKey("id") && noId == false) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    }
    if (_json.containsKey("competences")) {
      competences = _json["competences"].map((value) => new Competence.fromJson(value, noId)).toList();
    }

    SubCategory subCategory = new SubCategory((_json["id"]==null ? null : core.int.parse(_json["id"])),
        name, description, competences);
    return subCategory;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = description;
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (competences != null) {
      _json["competences"] = competences.map((value) => (value).toJson()).toList();
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}