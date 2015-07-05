library akepot.model.model_competence;

import 'package:polymer/polymer.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Competence extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("competenceTemplates/"+id, new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */ //TODO: label
  String _label = "";
  String get label => _label;
  void set label(String value) {
    this._label = notifyPropertyChange(const Symbol('label'), this._label, value);

    _changeProperty("competenceTemplates/"+id, new Map()..putIfAbsent("label", () => label));
  }

  /** Not documented yet. */
  int _rating = 0;
  int get rating => _rating;
  void set rating(int value) {
    this._rating = notifyPropertyChange(const Symbol('rating'), this._rating, value);

    _changeProperty("competenceTemplates/"+id, new Map()..putIfAbsent("rating", () => rating));
  }

  @observable bool notSetYet;

  @observable int competenceTemplateId;

  @observable int userId;

  @observable CompetencesService service;

  Competence.full(this.id, this._label, this._description, this._rating, this.notSetYet, this.competenceTemplateId, this.userId);

  Competence.newId(this.id);

  Competence.emptyDefault() {
    _label = "New Competence";
  }

  factory Competence.retrieve(String id, CompetencesService service) {
    Competence competence = toObservable(new Competence.newId(id));
    service.dbRef.child("competenceTemplates/"+id).once("value").then((snapshot) {
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
    Firebase pushRef = service.dbRef.child("competenceTemplates").push();
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

  toString() => label;

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("competenceTemplates/"+id+"/label").onValue.listen((e) {
      _label = notifyPropertyChange(const Symbol('label'), this._label, e.snapshot.val());
    });
    service.dbRef.child("competenceTemplates/"+id+"/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });
    service.dbRef.child("competenceTemplates/"+id+"/rating").onValue.listen((e) {
      _rating = notifyPropertyChange(const Symbol('rating'), this._rating, e.snapshot.val());
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
    /*if (!_json.containsKey("competenceTemplateId") && noId == false) {
      throw new Exception("No competenceTemplateId.");
    }
    competenceTemplateId = _json["competenceTemplateId"]==null ? null : int.parse(_json["competenceTemplateId"]);
    if (!_json.containsKey("userId") && noId == false) {
      throw new Exception("No userId.");
    }
    userId = _json["userId"]==null ? null : int.parse(_json["userId"]);
    */
  }

  Map toJson() {
    var _json = new Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (label != null) {
      _json["label"] = label;
    }
    if (description != null) {
      _json["description"] = description;
    }
    if (rating != null) {
      _json["rating"] = rating;
    }
    _json["notSetYet"] = notSetYet;
    /*if (competenceTemplateId != null) {
      _json["competenceTemplateId"] = competenceTemplateId;
    }
    if (userId != null) {
      _json["userId"] = userId;
    }*/
    return _json;
  }

}