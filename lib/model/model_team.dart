library akepot.model.model_team;

import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class Team extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/$projectHash/teams/$id", new Map()..putIfAbsent("description", () => description));
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

    _changeProperty("projects/$projectHash/teams/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Person> persons = toObservable([]);
  @observable ObservableMap personIds = toObservable(new Map());

  @observable CompetencesService service;

  Team.full(this.id, String this.projectHash, this._name, this._description, this.persons);

  Team.newId(this.id, String this.projectHash);

  Team.emptyDefault() {
    _name = "New Team";
  }

  factory Team.retrieve(String id, String projectHash, CompetencesService service) {
    Team team = toObservable(new Team.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/teams/$id").once("value").then((snapshot) {
      Map val = snapshot.val();

      if(val != null) {
        team.fromJson(val);
        team._listen(service);
      } else {
        //New team
        team = toObservable(new Team.newRemote(projectHash, service));
      }
    });
    return team;
  }

  factory Team.newRemote(String projectHash, CompetencesService service) {
    Team team = toObservable(new Team.emptyDefault());
    ThenableReference pushRef = service.dbRef.child("projects/$projectHash/teams").push();
    team.id = pushRef.key;
    team.projectHash = projectHash;
    pushRef.set(team.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        team._listen(service);
      }
    });
    return team;
  }

  toString() => id + ": " + name;//TODO

  Person addPerson(String uid){
    Person person = new Person.newRemote(service, uid, projectHash);
    service.dbRef.child("projects/$projectHash/teams/$id/personIds").update(new Map()..putIfAbsent(person.id, () => true));
    return person;
  }

  addPersonFull(Person person){
    service.dbRef.child("projects/$projectHash/teams/$id/personIds").update(new Map()..putIfAbsent(person.id, () => true));
    return person;
  }

  removePerson(int index){
    String personId = persons[index].id;
    service.dbRef.child("projects/$projectHash/teams/$id/personIds/$personId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$projectHash/teams/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/teams/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    personIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Person person = new Person.retrieve(record.key, projectHash, service);
            persons.add(person);//TODO
          }

          //Something removed
          if (record.isRemove) {
            persons.removeWhere((person) => person.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$projectHash/teams/$id/personIds").onChildAdded.listen((e) {
      personIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$projectHash/teams/$id/personIds").onChildRemoved.listen((e) {
      personIds.remove(e.snapshot.key);
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
    if (_json.containsKey("name")) {
      name = _json["name"];
    } else {
      name = "Unknown Team";
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
