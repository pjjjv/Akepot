library akepot.model.model_role;

import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class Role extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/$projectHash/roles/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("projects/$projectHash/roles/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
//  @observable List<CompetenceLevel> competenceLevels = toObservable([]);
//  @observable ObservableMap competenceLevelIds = toObservable(new Map());

  @observable CompetencesService service;

  Role.full(this.id, String this.projectHash, this._name, this._description);

  Role.newId(this.id, String this.projectHash);

  Role.emptyDefault() {
    _name = "New Role";
  }

  factory Role.retrieve(String id, String projectHash, CompetencesService service) {
    Role role = toObservable(new Role.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/roles/$id").once("value").then((snapshot) {
      Map val = snapshot.val();

      if(val != null) {
        role.fromJson(val);
        role._listen(service);
      } else {
        //New role
        role = toObservable(new Role.newRemote(projectHash, service));
      }
    });
    return role;
  }

  factory Role.newRemote(String projectHash, CompetencesService service) {
    Role role = toObservable(new Role.emptyDefault());
    ThenableReference pushRef = service.dbRef.child("projects/$projectHash/roles").push();
    role.id = pushRef.key;
    role.projectHash = projectHash;
    pushRef.set(role.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        role._listen(service);
      }
    });
    return role;
  }

  toString() => id + ": " + name;//TODO

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$projectHash/roles/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/roles/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });
//
//    competenceLevelIds.changes.listen((records) {
//      for (ChangeRecord record in records) {
//        //We don't need to do anything with PropertyChangeRecords.
//        if (record is MapChangeRecord) {
//          //Something added
//          if (record.isInsert) {
//            CompetenceLevel competenceLevel = new CompetenceLevel.retrieve(record.key, projectHash, service);
//            competenceLevels.add(competenceLevel);//TODO));
//          }
//
//          //Something removed
//          if (record.isRemove) {
//            competenceLevels.removeWhere((competenceLevel) => competenceLevel.id == record.key);
//          }
//        }
//      }
//    });
//
//    service.dbRef.child("projects/$projectHash/roles/$id/competenceLevelIds").onChildAdded.listen((e) {
//      competenceLevelIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
//    });
//
//    service.dbRef.child("projects/$projectHash/roles/$id/competenceLevelIds").onChildRemoved.listen((e) {
//      competenceLevelIds.remove(e.snapshot.key);
//    });
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
    if (_json.containsKey("name")) {
      name = _json["name"];
    } else {
      name = "Unknown Role";
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    } else {
      description = "-";
    }
    /*if (_json.containsKey("subCategories")) {
      subcategories = toObservable(_json["subCategories"].map((value) => new SubCategory.fromJson(value, noId)).toList());
    }*/
  }

  Map<String, dynamic> toJson() {
    var _json = new Map<String, dynamic>();
    if (description != null) {
      _json["description"] = description;
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
    }
    if (name != null) {
      _json["name"] = name;
    }
    /*if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}
