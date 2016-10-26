library akepot.model.model_person;

import 'package:akepot/model/model_role.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';
import 'dart:developer';

/** Not documented yet. */
class Person extends Observable {
  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  @observable String projectHash;

  /** Not documented yet. */
  String _nickName = "";
  String get nickName => _nickName;
  void set nickName(String value) {
    this._nickName = notifyPropertyChange(const Symbol('nickName'), this._nickName, value);

    _changeProperty("projects/$projectHash/persons/$id", new Map()..putIfAbsent("nickName", () => nickName));
  }

  /** Not documented yet. */
  String _emailAddress = "";
  String get emailAddress => _emailAddress;
  void set emailAddress(String value) {
    this._emailAddress = notifyPropertyChange(const Symbol('emailAdress'), this._emailAddress, value);

    _changeProperty("projects/$projectHash/persons/$id", new Map()..putIfAbsent("emailAddress", () => emailAddress));
  }

  /** Not documented yet. */
  String _firstName = "";
  String get firstName => _firstName;
  void set firstName(String value) {
    this._firstName = notifyPropertyChange(const Symbol('firstName'), this._firstName, value);

    _changeProperty("projects/$projectHash/persons/$id", new Map()..putIfAbsent("firstName", () => firstName));
  }

  /** Not documented yet. */
  String _lastName = "";
  String get lastName => _lastName;
  void set lastName(String value) {
    this._lastName = notifyPropertyChange(const Symbol('lastName'), this._lastName, value);

    _changeProperty("projects/$projectHash/persons/$id", new Map()..putIfAbsent("lastName", () => lastName));
  }

  /** Not documented yet. */
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  void set isAdmin(bool value) {
    this._isAdmin = notifyPropertyChange(const Symbol('isAdmin'), this._isAdmin, value);

    _changeProperty("projects/$projectHash/persons/$id", new Map()..putIfAbsent("isAdmin", () => isAdmin));

  }

  /** Not documented yet. */
  @observable List<Role> roles = toObservable([]);
  @observable ObservableMap roleIds = toObservable(new Map());

  /* For report only */
  /** Not documented yet. */
  String get name => nickName;
  void set name(String value) { }

  @observable CompetencesService service;

  Person.full(this.id, String this.projectHash, this._nickName, this._emailAddress, this._firstName, this._lastName, this._isAdmin, this.roles);

  Person.newId(this.id, String this.projectHash);

  Person.emptyDefault() {
    _nickName = "New Person";
  }

  factory Person.retrieve(String id, String projectHash, CompetencesService service, [dynamic callback(Person person)]) {
    Person person = toObservable(new Person.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/persons/$id").once("value").then((event) {
      Map val = event.snapshot.val();
      if(val != null){
        person.fromJson(val);
      } else {
        person = null;
      }

      if(person != null) {
        person._listen(service);
      } else {
        //New person
        person = toObservable(new Person.newRemote(service, id, projectHash));
      }

      if(callback != null){
        callback(person);
      }
    });
    return person;
  }

  factory Person.newRemote(CompetencesService service, String uid, String projectHash, {String nickName, String emailAddress, String firstName, String lastName, bool admin: false}) {
    Person person = toObservable(new Person.emptyDefault());
    person.id = uid;
    person.projectHash = projectHash;
    if(nickName != null){
      person.nickName = nickName;
    }
    if(emailAddress != null){
      person.emailAddress = emailAddress;
    }
    if(firstName != null){
      person.firstName = firstName;
    }
    if(lastName != null){
      person.lastName = lastName;
    }
    person.isAdmin = admin;
    DatabaseReference setRef = service.dbRef.child("projects/$projectHash/persons/$uid");
    setRef.set(person.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        person._listen(service);
      }
    });
    person.service = service;
    return person;
  }

  static exists(String uid, String projectHash, CompetencesService service, dynamic callback(bool exists)) {
    service.dbRef.child('projects/$projectHash/persons/$uid').once("value").then((event) {
      Map val = event.snapshot.val();
      callback(val != null);
    });
  }

  toString() => id + ": " + nickName;//TODO

  assignRole(String roleId){
    service.dbRef.child("projects/$projectHash/persons/$id/roleIds").update(new Map()..putIfAbsent(roleId, () => true));
  }

  unassignRole(int index){
    String roleId = roles[index].id;
    service.dbRef.child("projects/$projectHash/persons/$id/roleIds/$roleId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$projectHash/persons/$id/nickName").onValue.listen((e) {
      _nickName = notifyPropertyChange(const Symbol('nickName'), this._nickName, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/persons/$id/emailAddress").onValue.listen((e) {
      _emailAddress = notifyPropertyChange(const Symbol('emailAddress'), this._emailAddress, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/persons/$id/firstName").onValue.listen((e) {
      _firstName = notifyPropertyChange(const Symbol('firstName'), this._firstName, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/persons/$id/lastName").onValue.listen((e) {
      _lastName = notifyPropertyChange(const Symbol('lastName'), this._lastName, e.snapshot.val());
    });
    service.dbRef.child("projects/$projectHash/persons/$id/isAdmin").onValue.listen((e) {
      _isAdmin = notifyPropertyChange(const Symbol('isAdmin'), this._isAdmin, e.snapshot.val());
    });

    roleIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Role role = new Role.retrieve(record.key, projectHash, service);
            roles.add(role);//TODO
          }

          //Something removed
          if (record.isRemove) {
            roles.removeWhere((role) => role.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$projectHash/persons/$id/roleIds").onChildAdded.listen((e) {
      roleIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$projectHash/persons/$id/roleIds").onChildRemoved.listen((e) {
      roleIds.remove(e.snapshot.key);
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  setAdmin(bool value, Project project){
    this.isAdmin = value;
    project.addAdmin(this);
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
    if (_json.containsKey("nickName")) {
      nickName = _json["nickName"];
    } else {
      nickName = "Unknown Person";
    }
    if (_json.containsKey("emailAddress")) {
      emailAddress = _json["emailAddress"];
    } else {
      emailAddress = "-";
    }
    if (_json.containsKey("firstName")) {
      firstName = _json["firstName"];
    } else {
      firstName = "Unknown";
    }
    if (_json.containsKey("lastName")) {
      lastName = _json["lastName"];
    } else {
      lastName = "Person";
    }
    if (_json.containsKey("isAdmin")) {
      isAdmin = _json["isAdmin"].toString().toLowerCase() == 'true';
    } else {
      isAdmin = false;
    }
    /*if (_json.containsKey("subCategories")) {
      subcategories = toObservable(_json["subCategories"].map((value) => new SubCategory.fromJson(value, noId)).toList());
    }*/
  }

  Map<String, dynamic> toJson() {
    var _json = new Map<String, dynamic>();
    if (id != null) {
      _json["id"] = id;
    }
    if (projectHash != null) {
      _json["projectHash"] = projectHash;
    }
    if (nickName != null) {
      _json["nickName"] = nickName;
    }
    if (emailAddress != null) {
      _json["emailAddress"] = emailAddress;
    }
    if (firstName != null) {
      _json["firstName"] = firstName;
    }
    if (lastName != null) {
      _json["lastName"] = lastName;
    }
    _json["isAdmin"] = isAdmin;
    /*if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}
