library akepot.model.model_competencelevel;

import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class CompetenceLevel extends Observable {

  /** Not documented yet. */
  @observable String tid;

  /** Not documented yet. */
  @observable String rid;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  int _level = 0;
  @observable int get level => _level;
  @observable void set level(int value) {
    this._level = notifyPropertyChange(const Symbol('level'), this._level, value);

    _changeProperty("projects/$projectHash/roles/$rid/competences/$tid", new Map()..putIfAbsent("level", () => level));
  }

  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String label = "";

  @observable CompetencesService service;

  CompetenceLevel.full(String this.projectHash, this.rid, this.tid, this._level);

  CompetenceLevel.newId(String this.projectHash, this.rid, this.tid);

  CompetenceLevel.emptyDefault(){
    label = "Unknown Competence";
    description = "-";
  }

  factory CompetenceLevel.retrieveMatch(String projectHash, String roleId, String competenceTemplateId, CompetencesService service) {
    if(roleId == null){
      throw new Exception("roleId null.");
    }
    if(projectHash == null){
      throw new Exception("projectHash null.");
    }

    CompetenceLevel competenceLevel = toObservable(new CompetenceLevel.newId(projectHash, roleId, competenceTemplateId));

    service.dbRef.child("projects/$projectHash/roles/$roleId/competences/$competenceTemplateId").once("value").then((snapshot) {
      Map val = snapshot.val();

      if(val != null) {
        competenceLevel.fromJson(val);
        competenceLevel._listen(service);
      } else {
        //New competence level copied from template
        competenceLevel = toObservable(new CompetenceLevel.newRemoteFromTemplate(projectHash, roleId, competenceTemplateId, service));
      }
    });
    return competenceLevel;
  }

  factory CompetenceLevel.newRemoteFromTemplate(String projectHash, String roleId, String competenceTemplateId, CompetencesService service) {
    if(roleId == null){
      throw new Exception("roleId null.");
    }

    CompetenceLevel competenceLevel = toObservable(new CompetenceLevel.emptyDefault());
    Firebase ref = service.dbRef.child("projects/$projectHash/roles/$roleId/competences/$competenceTemplateId");
    competenceLevel.projectHash = projectHash;
    competenceLevel.rid = roleId;
    competenceLevel.tid = competenceTemplateId;
    ref.update(competenceLevel.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        competenceLevel._listen(service);
      }
    });
    return competenceLevel;
  }

  toString() => level;

  addLevelChangeListener(CompetencesService service, dynamic listener){
    service.dbRef.child("projects/$projectHash/roles/$rid/competences/$tid/level").onValue.listen(listener);
  }

  _listen(CompetencesService service){
    this.service = service;

    if(rid == null){
      throw new Exception("rid null.");
    }

    service.dbRef.child("projects/$projectHash/roles/$rid/competences/$tid/level").onValue.listen((e) {
      _level = notifyPropertyChange(const Symbol('level'), this._level, e.snapshot.val());
    });

    service.dbRef.child("projects/$projectHash/competenceTemplates/$tid/label").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "Unknown competence";
      label = value;
    });
    service.dbRef.child("projects/$projectHash/competenceTemplates/$tid/description").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "-";
      description = value;
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("tid") && noId == false) {
      throw new Exception("No tid.");
    }
    if (!_json.containsKey("rid") && noId == false) {
      throw new Exception("No rid.");
    }
    if (!_json.containsKey("projectHash") && noId == false) {
      throw new Exception("No projectHash.");
    }
    tid = _json["tid"]==null ? null : _json["tid"];
    rid = _json["rid"]==null ? null : _json["rid"];
    projectHash = _json["projectHash"]==null ? null : _json["projectHash"];
    if (_json.containsKey("level")) {
      level = _json["level"];
    } else {
      level = 0;
    }
  }

  Map toJson() {
    var _json = new Map();
    if (tid != null) {
      _json["tid"] = tid;
    }
    if (rid != null) {
      _json["rid"] = rid;
    }
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
    }
    if (level != null) {
      _json["level"] = level;
    }
    return _json;
  }

}