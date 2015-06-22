library akepot.model.model_category;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/model/model_subcategory.dart';


/** Not documented yet. */
class Category extends Observable {
  /** Not documented yet. */
  @observable core.String description;

  /** Not documented yet. */
  @observable core.int id;

  /** Not documented yet. */
  @observable core.String name;

  /** Not documented yet. */
  @observable core.List<SubCategory> subcategories = toObservable([]);

  Category(this.id, this.name, this.description, this.subcategories);
  Category.create() : id = null, name = "New", description = "", subcategories = toObservable([]);

  toString() => name;

  factory Category.fromJson(core.Map _json, [core.bool noId = false]) {
    core.String name = "SubCategory";
    core.String description = "-";
    core.List<SubCategory> subcategories = toObservable([]);

    if (!_json.containsKey("id") && noId == false) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    }
    if (_json.containsKey("subCategories")) {
      subcategories = toObservable(_json["subCategories"].map((value) => new SubCategory.fromJson(value, noId)).toList());
    }

    Category category = new Category((_json["id"]==null ? null : core.int.parse(_json["id"])),
        name, description, subcategories);
    return category;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (description != null) {
      _json["description"] = description;
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
