library akepot.model.model_competence;

import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';
import 'package:akepot/model/model_competencetemplate.dart';

/** Not documented yet. */
class Competence extends Observable {

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  bool _notSetYet = true;
  bool get notSetYet => _notSetYet;
  void set notSetYet(bool value) {
    this._notSetYet = notifyPropertyChange(const Symbol('notSetYet'), this._notSetYet, value);

    _changeProperty("competences/$id", new Map()..putIfAbsent("notSetYet", () => notSetYet));
  }

  /** Not documented yet. */
  int _rating = 0;
  int get rating => _rating;
  void set rating(int value) {
    this._rating = notifyPropertyChange(const Symbol('rating'), this._rating, value);

    _changeProperty("competences/$id", new Map()..putIfAbsent("rating", () => rating));
  }

  /** Not documented yet. */
  @observable int competenceTemplateId;

  /** Not documented yet. */
  @observable String description = "";

  /** Not documented yet. */
  @observable String label = "";

  @observable CompetencesService service;

  Competence.full(this.id, this._notSetYet, this._rating, this.competenceTemplateId);

  Competence.newId(this.id);

  Competence.emptyDefault(){
    label = "Unknown Competence";
    description = "-";
  }

  factory Competence.retrieve(String id, CompetencesService service) {
    Competence competence = toObservable(new Competence.newId(id));
    service.dbRef.child("competences/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      competence.fromJson(val);

      if(competence != null) {
        competence._listen(service);
      } else {
        //New competence
        competence = toObservable(new Competence.newRemote(service));
      }
    });
    return competence;
  }

  factory Competence.newRemote(CompetencesService service) {
    Competence competence = toObservable(new Competence.emptyDefault());
    Firebase pushRef = service.dbRef.child("competences").push();
    competence.id = pushRef.key;
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
    service.dbRef.child("competences/$id/notSetYet").onValue.listen((e) {
      _notSetYet = notifyPropertyChange(const Symbol('notSetYet'), this._notSetYet, e.snapshot.val());
    });
    service.dbRef.child("competences/$id/rating").onValue.listen((e) {
      _rating = notifyPropertyChange(const Symbol('rating'), this._rating, e.snapshot.val());
    });

    service.dbRef.child("competenceTemplates/$competenceTemplateId/label").onValue.listen((e) {
      String value = e.snapshot.val();
      if (value == null) value = "Unknown competence";//TODO
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