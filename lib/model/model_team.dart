library akepot.model.model_team;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Team extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("teams/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("teams/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Person> persons = toObservable([]);
  @observable ObservableMap personIds = toObservable(new Map());

  @observable CompetencesService service;

  Team.full(this.id, this._name, this._description, this.persons);

  Team.newId(this.id);

  Team.emptyDefault() {
    _name = "New Team";
  }

  factory Team.retrieve(String id, CompetencesService service) {
    Team team = toObservable(new Team.newId(id));
    service.dbRef.child("teams/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      team.fromJson(val);

      if(team != null) {
        team._listen(service);
      } else {
        //New team
        team = toObservable(new Team.newRemote(service));
      }
    });
    return team;
  }

  factory Team.newRemote(CompetencesService service) {
    Team team = toObservable(new Team.emptyDefault());
    Firebase pushRef = service.dbRef.child("teams").push();
    team.id = pushRef.key;
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

  addPerson(){
    Person person = new Person.newRemote(service);
    service.dbRef.child("persons/$id/personIds").update(new Map()..putIfAbsent(person.id, () => true));
  }

  removePerson(int index){
    String personId = persons[index].id;
    service.dbRef.child("persons/$id/personIds/$personId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("teams/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("teams/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    personIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Person person = new Person.retrieve(record.key, service);
            persons.add(person);//TODO
          }

          //Something removed
          if (record.isRemove) {
            persons.removeWhere((person) => person.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("persons/$id/personIds").onChildAdded.listen((e) {
      personIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("persons/$id/personIds").onChildRemoved.listen((e) {
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
    id = _json["id"]==null ? null : _json["id"];
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
    if (name != null) {
      _json["name"] = name;
    }
    /*if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}
