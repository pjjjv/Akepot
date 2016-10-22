library akepot.model.model_competence;

import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class Competence extends Observable {

  /** Not documented yet. */
  @observable String tid;

  /** Person id */
  @observable String uid;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  bool _notSetYet = true;
  bool get notSetYet => _notSetYet;
  void set notSetYet(bool value) {
    this._notSetYet = notifyPropertyChange(const Symbol('notSetYet'), this._notSetYet, value);

    if(uid == null){
      throw new Exception("uid null.");
    }

    _changeProperty("projects/$projectHash/persons/$uid/competences/$tid", new Map()..putIfAbsent("notSetYet", () => notSetYet));
  }

  /** Not documented yet. */
  int _rating = 0;
  int get rating => _rating;
  void set rating(int value) {
    this._rating = notifyPropertyChange(const Symbol('rating'), this._rating, value);

    if(uid == null){
      throw new Exception("uid null.");
    }

    _changeProperty("projects/$projectHash/persons/$uid/competences/$tid", new Map()..putIfAbsent("rating", () => rating));
  }

  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String label = "";

  @observable CompetencesService service;

  Competence.full(String this.projectHash, this.uid, this.tid, this._notSetYet, this._rating);

  Competence.newId(String this.projectHash, this.uid, this.tid);

  Competence.emptyDefault(){
    label = "Unknown Competence";
    description = "-";
  }

  factory Competence.retrieveMatch(String projectHash, String personId, String competenceTemplateId, CompetencesService service) {
    if(personId == null){
      throw new Exception("personId null.");
    }
    if(projectHash == null){
      throw new Exception("projectHash null.");
    }

    Competence competence = toObservable(new Competence.newId(projectHash, personId, competenceTemplateId));

    service.dbRef.child("projects/$projectHash/persons/$personId/competences/$competenceTemplateId").once("value").then((snapshot) {
      Map val = snapshot.val();

      if(val != null) {
        competence.fromJson(val);
        competence._listen(service);
      } else {
        //New competence copied from template
        competence = toObservable(new Competence.newRemoteFromTemplate(projectHash, personId, competenceTemplateId, service));
      }
    });
    return competence;
  }

  factory Competence.newRemoteFromTemplate(String projectHash, String personId, String competenceTemplateId, CompetencesService service) {
    if(personId == null){
      throw new Exception("personId null.");
    }

    Competence competence = toObservable(new Competence.emptyDefault());
    Firebase ref = service.dbRef.child("projects/$projectHash/persons/$personId/competences/$competenceTemplateId");
    competence.projectHash = projectHash;
    competence.uid = personId;
    competence.tid = competenceTemplateId;
    ref.update(competence.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        competence._listen(service);
      }
    });
    return competence;
  }

  toString() => rating;

  _listen(CompetencesService service){
    this.service = service;

    if(uid == null){
      throw new Exception("uid null.");
    }

    service.dbRef.child("projects/$projectHash/persons/$uid/competences/$tid/notSetYet").onValue.listen((e) {
      _notSetYet = notifyPropertyChange(const Symbol('notSetYet'), this._notSetYet, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/persons/$uid/competences/$tid/rating").onValue.listen((e) {
      _rating = notifyPropertyChange(const Symbol('rating'), this._rating, e.snapshot.val());
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
    if (!_json.containsKey("uid") && noId == false) {
      throw new Exception("No uid.");
    }
    if (!_json.containsKey("projectHash") && noId == false) {
      throw new Exception("No projectHash.");
    }
    tid = _json["tid"]==null ? null : _json["tid"];
    uid = _json["uid"]==null ? null : _json["uid"];
    projectHash = _json["projectHash"]==null ? null : _json["projectHash"];
    if (_json.containsKey("rating")) {
      rating = _json["rating"];
    } else {
      rating = 0;
    }
    if (_json.containsKey("notSetYet")) {
      notSetYet = _json["notSetYet"].toString().toLowerCase() == 'true';
    } else {
      notSetYet = true;
    }
  }

  Map toJson() {
    var _json = new Map();
    if (tid != null) {
      _json["tid"] = tid;
    }
    if (uid != null) {
      _json["uid"] = uid;
    }
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
    }
    if (rating != null) {
      _json["rating"] = rating;
    }
    _json["notSetYet"] = notSetYet;
    return _json;
  }

}
