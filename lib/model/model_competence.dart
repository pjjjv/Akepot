library akepot.model.model_competence;

import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Competence extends Observable {

  /** Not documented yet. */
  @observable String id;

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

    _changeProperty("persons/$uid/competences/$id", new Map()..putIfAbsent("notSetYet", () => notSetYet));
  }

  /** Not documented yet. */
  int _rating = 0;
  int get rating => _rating;
  void set rating(int value) {
    this._rating = notifyPropertyChange(const Symbol('rating'), this._rating, value);

    if(uid == null){
      throw new Exception("uid null.");
    }

    _changeProperty("persons/$uid/competences/$id", new Map()..putIfAbsent("rating", () => rating));
  }

  /** Not documented yet. */
  @observable String competenceTemplateId;

  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String label = "";

  @observable CompetencesService service;

  Competence.full(this.id, this.uid, this._notSetYet, this._rating, this.competenceTemplateId);

  Competence.newId(this.id, this.uid);

  Competence.emptyDefault(){
    label = "Unknown Competence";
    description = "-";
  }

  factory Competence.retrieve(String id, String personId, CompetencesService service) {
    if(personId == null){
      throw new Exception("personId null.");
    }

    Competence competence = toObservable(new Competence.newId(id, personId));
    service.dbRef.child("persons/$personId/competences/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      competence.fromJson(val);

      if(competence != null) {
        competence._listen(service);
      } else {
        //New competence
        competence = toObservable(new Competence.newRemote(personId, service));
      }
    });
    return competence;
  }

  factory Competence.retrieveMatch(String competenceTemplateId, String personId, CompetencesService service){
    if(personId == null){
      throw new Exception("personId null.");
    }

    Competence competence = toObservable(new Competence.fromTemplate(competenceTemplateId, personId, service));
    service.dbRef.child("persons/$personId/competences").orderByChild("competenceTemplateId").equalTo(competenceTemplateId).limitToFirst(1).once("value").then((snapshot) {
      Map val = snapshot.val();
      if(val == null || val.keys.isEmpty) {
        //New competence copied from template
      } else {
        Map deeper = val[val.keys.first];
        String oldId = competence.id;
        competence.fromJson(deeper);

        if(competence != null) {
          //Remove the temporary created (and registered one)
          service.dbRef.child("persons/$personId/competences/$oldId").remove();

          competence._listen(service);
        } else {
          //New competence copied from template
        }
      }
    });
    return competence;
  }

  factory Competence.newRemote(String personId, CompetencesService service) {
    if(personId == null){
      throw new Exception("personId null.");
    }

    Competence competence = toObservable(new Competence.emptyDefault());
    Firebase pushRef = service.dbRef.child("persons/$personId/competences").push();
    competence.id = pushRef.key;
    competence.uid = personId;
    pushRef.set(competence.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        competence._listen(service);
      }
    });
    return competence;
  }

  factory Competence.fromTemplate(String competenceTemplateId, String personId, CompetencesService service) {
    if(personId == null){
      throw new Exception("personId null.");
    }

    Competence competence = toObservable(new Competence.emptyDefault());
    Firebase pushRef = service.dbRef.child("persons/$personId/competences").push();
    competence.id = pushRef.key;
    competence.uid = personId;
    competence.competenceTemplateId = competenceTemplateId;
    pushRef.set(competence.toJson()).then((error) {
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

    service.dbRef.child("persons/$uid/competences/$id/notSetYet").onValue.listen((e) {
      _notSetYet = notifyPropertyChange(const Symbol('notSetYet'), this._notSetYet, e.snapshot.val());
    });
    service.dbRef.child("persons/$uid/competences/$id/rating").onValue.listen((e) {
      _rating = notifyPropertyChange(const Symbol('rating'), this._rating, e.snapshot.val());
    });

    service.dbRef.child("projects/$projectHash/competenceTemplates/$competenceTemplateId/label").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "Unknown competence";
      label = value;
    });
    service.dbRef.child("projects/$projectHash/competenceTemplates/$competenceTemplateId/description").onValue.listen((e) {
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
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    if (!_json.containsKey("uid") && noId == false) {
      throw new Exception("No uid.");
    }
    id = _json["id"]==null ? null : _json["id"];
    uid = _json["uid"]==null ? null : _json["uid"];
    if (!_json.containsKey("competenceTemplateId")) {
      throw new Exception("No competenceTemplateId.");
    }
    competenceTemplateId = _json["competenceTemplateId"];
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
    if (id != null) {
      _json["id"] = id;
    }
    if (uid != null) {
      _json["uid"] = uid;
    }
    if (rating != null) {
      _json["rating"] = rating;
    }
    _json["notSetYet"] = notSetYet;
    if (competenceTemplateId != null) {
      _json["competenceTemplateId"] = competenceTemplateId;
    }
    return _json;
  }

}