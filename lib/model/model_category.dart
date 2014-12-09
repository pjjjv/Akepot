library akepot.model.model_category;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_subcategory.dart';


/** Not documented yet. */
class Category extends Observable {
  /** Not documented yet. */
  final Text description;

  /** Not documented yet. */
  final core.Map id;

  /** Not documented yet. */
  final core.String name;

  /** Not documented yet. */
  final core.List<SubCategory> subcategories;

  Category(this.id, this.name, this.description, this.subcategories);

  toString() => name;

  factory Category.fromJson(core.Map _json) {
    core.String name = "SubCategory";
    Text description = new Text("-");
    core.List<SubCategory> subcategories = [];

    if (!_json.containsKey("id")) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = new Text.fromJson(_json["description"]);
    }
    if (_json.containsKey("subCategories")) {
      subcategories = _json["subCategories"].map((value) => new SubCategory.fromJson(value)).toList();
    }

    Category category = new Category(_json["id"], name, description,
        subcategories);
    return category;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = (description).toJson();
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }
    return _json;
  }
}
