library akepot.model.model_competencetemplate;

import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class CompetenceTemplate extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/$projectHash/competenceTemplates/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  String _label = "";
  String get label => _label;
  void set label(String value) {
    this._label = notifyPropertyChange(const Symbol('label'), this._label, value);

    _changeProperty("projects/$projectHash/competenceTemplates/$id", new Map()..putIfAbsent("label", () => label));
  }

  @observable CompetencesService service;

  CompetenceTemplate.full(this.id, String this.projectHash, this._label, this._description);

  CompetenceTemplate.newId(this.id, String this.projectHash);

  CompetenceTemplate.emptyDefault() {
    _label = "New Competence";
  }

  factory CompetenceTemplate.retrieve(String id, String projectHash, CompetencesService service) {
    CompetenceTemplate competenceTemplate = toObservable(new CompetenceTemplate.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/competenceTemplates/$id").once("value").then((event) {
      Map val = event.snapshot.val();

      if(val != null) {
        competenceTemplate.fromJson(val);
        competenceTemplate._listen(service);
      } else {
        //New competence
        competenceTemplate = toObservable(new CompetenceTemplate.newRemote(projectHash, service));
      }
    });
    return competenceTemplate;
  }

  factory CompetenceTemplate.newRemote(String projectHash, CompetencesService service) {
    CompetenceTemplate competenceTemplate = toObservable(new CompetenceTemplate.emptyDefault());
    ThenableReference pushRef = service.dbRef.child("projects/$projectHash/competenceTemplates").push();
    competenceTemplate.id = pushRef.key;
    competenceTemplate.projectHash = projectHash;
    pushRef.set(competenceTemplate.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        competenceTemplate._listen(service);
      }
    });
    return competenceTemplate;
  }

  toString() => label;

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$projectHash/competenceTemplates/$id/label").onValue.listen((e) {
      _label = notifyPropertyChange(const Symbol('label'), this._label, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/competenceTemplates/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    if (!_json.containsKey("projectHash") && noId == false) {
      throw new Exception("No projectHash.");
    }
    id = _json["id"]==null ? null : _json["id"];
    projectHash = _json["projectHash"]==null ? null : _json["projectHash"];
    if (_json.containsKey("label")) {
      label = _json["label"];
    } else {
      label = "Unknown Competence";
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    } else {
      description = "-";
    }
  }

  Map toJson() {
    var _json = new Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
    }
    if (label != null) {
      _json["label"] = label;
    }
    if (description != null) {
      _json["description"] = description;
    }
    return _json;
  }

}
