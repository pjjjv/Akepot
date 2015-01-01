library akepot.model.model_competence;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/competences_service.dart';

/** Not documented yet. */
class Competence extends Observable {
  /** Not documented yet. */
  final Text description;
  /*Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
        non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.*/

  /** Not documented yet. */
  final core.Map id;

  /** Not documented yet. */
  final core.String label;

  /** Not documented yet. */
  final Rating value;

  final core.bool newCompetence;

  final core.Map templateId;

  Competence(this.id, this.label, this.description, this.value, this.newCompetence, this.templateId);

  toString() => label;

  factory Competence.fromJson(core.Map _json, [core.bool noId = false]) {
    core.String label = "Competence";
    Text description = new Text("-");
    Rating value = new Rating(0);
    core.bool newCompetence = true;

    if (!_json.containsKey("id") && noId == false) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("label")) {
      label = _json["label"];
    }
    if (_json.containsKey("description")) {
      description = new Text.fromJson(_json["description"]);
    }
    if (_json.containsKey("value")) {
      value = new Rating.fromJson(_json["value"]);
    }
    if (_json.containsKey("newCompetence")) {
      newCompetence = _json["newCompetence"].toString().toLowerCase() == 'true';
    }
    if (!_json.containsKey("templateId") && noId == false) {
      throw new core.Exception("No templateId.");
    }

    Competence competence = new Competence(_json["id"], label, description,
        value, newCompetence, _json["templateId"]);
    value.competence = competence;
    return competence;
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (label != null) {
      _json["label"] = label;
    }
    if (description != null) {
      _json["description"] = (description).toJson();
    }
    if (value != null) {
      _json["value"] = (value).toJson();
    }
    _json["newCompetence"] = newCompetence;
    if (templateId != null) {
      _json["templateId"] = templateId;
    }
    return _json;
  }

}


/** Not documented yet. */
class Rating extends Observable {
  /** Not documented yet. */
  core.int _rating;

  Competence competence;
  CompetencesService service;

  Rating(this._rating);

  toString() => _rating;

  factory Rating.fromJson(core.Map _json) {
    core.int rating = 0;
    if (_json.containsKey("rating")) {
      rating = _json["rating"];
    }
    return new Rating(rating);
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (_rating != null) {
      _json["rating"] = _rating;
    }
    return _json;
  }

  core.int get rating             => _rating;
  set rating(core.int rating) {
    _rating = rating;
    service.updateCompetence(competence);
  }
}


/** Not documented yet. */
class Text extends Observable {
  /** Not documented yet. */
  final core.String value;

  Text(this.value);

  toString() => value;

  factory Text.fromJson(core.Map _json) {
    core.String value = "-";
    if (_json.containsKey("value")) {
      value = _json["value"];
    }
    return new Text(value);
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (value != null) {
      _json["value"] = value;
    }
    return _json;
  }
}

