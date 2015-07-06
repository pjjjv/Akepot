library akepot.model.model_competencelevel;

import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';
import 'package:akepot/model/model_competencetemplate.dart';

/** Not documented yet. */
class CompetenceLevel extends Observable {

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  int _level = 0;
  int get level => _level;
  void set level(int value) {
    this._level = notifyPropertyChange(const Symbol('level'), this._level, value);

    _changeProperty("competenceLevels/$id", new Map()..putIfAbsent("level", () => level));
  }

  /** Not documented yet. */
  @observable int competenceTemplateId;

  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String label = "";

  @observable CompetencesService service;

  CompetenceLevel.full(this.id, this._level, this.competenceTemplateId);

  CompetenceLevel.newId(this.id);

  CompetenceLevel.emptyDefault(){
    label = "Unknown Competence";
    description = "-";
  }

  factory CompetenceLevel.retrieve(String id, CompetencesService service) {
    CompetenceLevel competenceLevel = toObservable(new CompetenceLevel.newId(id));
    service.dbRef.child("competenceLevels/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      competenceLevel.fromJson(val);

      if(competenceLevel != null) {
        competenceLevel._listen(service);
      } else {
        //New competenceLevel
        competenceLevel = toObservable(new CompetenceLevel.newRemote(service));
      }
    });
    return competenceLevel;
  }

  factory CompetenceLevel.newRemote(CompetencesService service) {
    CompetenceLevel competenceLevel = toObservable(new CompetenceLevel.emptyDefault());
    Firebase pushRef = service.dbRef.child("competenceLevels").push();
    competenceLevel.id = pushRef.key;
    pushRef.set(competenceLevel.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        competenceLevel._listen(service);
      }
    });
    return competenceLevel;
  }

  toString() => level;

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("competenceLevels/$id/level").onValue.listen((e) {
      _level = notifyPropertyChange(const Symbol('level'), this._level, e.snapshot.val());
    });

    service.dbRef.child("competenceTemplates/$competenceTemplateId/label").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "Unknown competenceLevel";//TODO
      label = notifyPropertyChange(const Symbol('label'), this.label, value);
    });
    service.dbRef.child("competenceTemplates/$competenceTemplateId/description").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "-";//TODO
      description = notifyPropertyChange(const Symbol('description'), this.description, value);
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
    id = _json["id"]==null ? null : _json["id"];
    if (!_json.containsKey("competenceTemplateId")) {
      throw new Exception("No competenceTemplateId.");
    }
    competenceTemplateId = _json["competenceTemplateId"];
    if (_json.containsKey("level")) {
      level = _json["level"];
    } else {
      level = 0;
    }
  }

  Map toJson() {
    var _json = new Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (level != null) {
      _json["level"] = level;
    }
    if (competenceTemplateId != null) {
      _json["competenceTemplateId"] = competenceTemplateId;
    }
    return _json;
  }

}