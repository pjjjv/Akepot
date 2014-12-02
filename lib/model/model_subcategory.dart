library akepot.model.model_subcategory;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/model/model_competence.dart';

/** Not documented yet. */
class SubCategory extends Observable {
  /** Not documented yet. */
  final Text description;

  /** Not documented yet. */
  final core.String id;

  /** Not documented yet. */
  final core.List<Competence> items;

  /** Not documented yet. */
  final core.String name;

  SubCategory(this.id, this.name, this.description, this.items);

  toString() => name;

  factory SubCategory.fromJson(core.Map _json) {
    core.String name = "SubCategory";
    Text description = new Text("-");
    core.List<Competence> items = [];

    if (!_json.containsKey("id")) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = new Text.fromJson(_json["description"]);
    }
    if (_json.containsKey("items")) {
      items = _json["items"].map((value) => new Competence.fromJson(value)).toList();
    }

    SubCategory subCategory = new SubCategory(_json["id"], name, description,
        items);
    return subCategory;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = (description).toJson();
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (items != null) {
      _json["items"] = items.map((value) => (value).toJson()).toList();
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}