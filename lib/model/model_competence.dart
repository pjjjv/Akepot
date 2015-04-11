library akepot.model.model_competence;

import 'package:polymer/polymer.dart';
import "dart:core" as core;
import 'package:akepot/competences_service.dart';

/** Not documented yet. */
class Competence extends Observable {
  /** Not documented yet. */
  final core.String description;

  /** Not documented yet. */
  final core.int id;

  /** Not documented yet. */
  final core.String label;

  /** Not documented yet. */
  final Rating value;

  final core.bool notSetYet;

  final core.int competenceTemplateId;

  final core.int userId;

  Competence(this.id, this.label, this.description, this.value, this.notSetYet, this.competenceTemplateId, this.userId);

  toString() => label;

  factory Competence.fromJson(core.Map _json, [core.bool noId = false]) {
    core.String label = "Competence";
    core.String description = "-";
    Rating value = new Rating(0);
    core.bool notSetYet = true;

    if (!_json.containsKey("id") && noId == false) {
      throw new core.Exception("No id.");
    }
    if (_json.containsKey("label")) {
      label = _json["label"];
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    }
    if (_json.containsKey("value")) {
      value = new Rating.fromJson(_json["value"]);
    }
    if (_json.containsKey("notSetYet")) {
      notSetYet = _json["notSetYet"].toString().toLowerCase() == 'true';
    }
    if (!_json.containsKey("competenceTemplateId") && noId == false) {
      throw new core.Exception("No competenceTemplateId.");
    }
    if (!_json.containsKey("userId") && noId == false) {
      throw new core.Exception("No userId.");
    }

    Competence competence = new Competence((_json["id"]==null ? null : core.int.parse(_json["id"])),
        label, description, value, notSetYet,
        (_json["competenceTemplateId"]==null ? null : core.int.parse(_json["competenceTemplateId"])),
        (_json["userId"]==null ? null : core.int.parse(_json["userId"])));
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
      _json["description"] = description;
    }
    if (value != null) {
      _json["value"] = (value).toJson();
    }
    _json["notSetYet"] = notSetYet;
    if (competenceTemplateId != null) {
      _json["competenceTemplateId"] = competenceTemplateId;
    }
    if (userId != null) {
      _json["userId"] = userId;
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

