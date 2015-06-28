library akepot.model.model_project;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_category.dart';
import "package:json_object/json_object.dart";

abstract class ProjectIfc extends Observable {
  /** Not documented yet. */
  @observable String hash;

  /** Not documented yet. */
  @observable String name = "New Project";

  /** Not documented yet. */
  @observable String description = "";

  JsonObject categoryIds;

  /** Not documented yet. */
  @observable List<Category> categories = toObservable([]);

  /** Not documented yet. */
  @observable List<String> teams = toObservable([]);

  /** Not documented yet. */
  String admin;
}


/** Not documented yet. */
class Project extends JsonObject implements ProjectIfc{

  String something;

  Project.full(this.hash, this.name, this.description, this.categories, this.teams, this.admin);

  Project.create(hash) : hash = hash, name = "New Project", description = "", categories = toObservable([]), teams = toObservable([]), admin = null;

  Project.empty();

  factory Project.fromJsonString(string){
    Project p = new JsonObject.fromJsonString(string, new Project.empty());
    return p;
  }

  toString() => name;

}
