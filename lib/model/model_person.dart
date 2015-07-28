library akepot.model.model_person;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_role.dart';
import 'package:akepot/model/model_competence.dart';
import 'package:akepot/model/model_competencetemplate.dart';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Person extends Observable {
  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _nickName = "";
  String get nickName => _nickName;
  void set nickName(String value) {
    this._nickName = notifyPropertyChange(const Symbol('nickName'), this._nickName, value);

    _changeProperty("persons/$id", new Map()..putIfAbsent("nickName", () => nickName));
  }

  /** Not documented yet. */
  String _emailAddress = "";
  String get emailAddress => _emailAddress;
  void set emailAddress(String value) {
    this._emailAddress = notifyPropertyChange(const Symbol('emailAdress'), this._emailAddress, value);

    _changeProperty("persons/$id", new Map()..putIfAbsent("emailAddress", () => emailAddress));
  }

  /** Not documented yet. */
  String _firstName = "";
  String get firstName => _firstName;
  void set firstName(String value) {
    this._firstName = notifyPropertyChange(const Symbol('firstName'), this._firstName, value);

    _changeProperty("persons/$id", new Map()..putIfAbsent("firstName", () => firstName));
  }

  /** Not documented yet. */
  String _lastName = "";
  String get lastName => _lastName;
  void set lastName(String value) {
    this._lastName = notifyPropertyChange(const Symbol('lastName'), this._lastName, value);

    _changeProperty("persons/$id", new Map()..putIfAbsent("lastName", () => lastName));
  }

  /** Not documented yet. */
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  void set isAdmin(bool value) {
    this._isAdmin = notifyPropertyChange(const Symbol('isAdmin'), this._isAdmin, value);

    _changeProperty("persons/$id", new Map()..putIfAbsent("isAdmin", () => isAdmin));

  }

  /** Not documented yet. */
  @observable List<Competence> competences = toObservable([]);
  @observable ObservableMap competenceIds = toObservable(new Map());

  /** Not documented yet. */
  @observable List<Role> roles = toObservable([]);//TODO: still add changes and listenres
  @observable ObservableMap roleIds = toObservable(new Map());

  @observable CompetencesService service;

  Person.full(this.id, this._nickName, this._emailAddress, this._firstName, this._lastName, this._isAdmin, this.competences, this.roles);

  Person.newId(this.id);

  Person.emptyDefault() {
    _nickName = "New Person";
  }

  factory Person.retrieve(String id, CompetencesService service, [dynamic callback(Person person)]) {
    Person person = toObservable(new Person.newId(id));
    service.dbRef.child("persons/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      person.fromJson(val);

      if(person != null) {
        person._listen(service);
      } else {
        //New person
        person = toObservable(new Person.newRemote(service, id));
      }

      if(callback != null){
        callback(person);
      }
    });
    return person;
  }

  factory Person.newRemote(CompetencesService service, String uid, {String nickName, String emailAddress, String firstName, String lastName, bool admin: false}) {
    Person person = toObservable(new Person.emptyDefault());
    person.id = uid;
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
    Firebase setRef = service.dbRef.child("persons/$uid");
    setRef.set(person.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        person._listen(service);
      }
    });
    return person;
  }

  static exists(String uid, CompetencesService service, dynamic callback(bool exists)) {
    service.dbRef.child('/persons/$uid').once("value").then((snapshot) {
      Map val = snapshot.val();
      callback(val != null);
    });
  }

  toString() => id + ": " + nickName;//TODO

//  addSubCategory(){
//    SubCategory subCategory = new SubCategory.newRemote(service);
//    service.dbRef.child("categories/$id/subCategoryIds").update(new Map()..putIfAbsent(subCategory.id, () => true));
//  }
//
//  removeSubCategory(int index){
//    String subCategoryId = subcategories[index].id;
//    service.dbRef.child("categories/$id/subCategoryIds/$subCategoryId").remove();
//  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("persons/$id/nickName").onValue.listen((e) {
      _nickName = notifyPropertyChange(const Symbol('nickName'), this._nickName, e.snapshot.val());
    });
    service.dbRef.child("persons/$id/emailAddress").onValue.listen((e) {
      _emailAddress = notifyPropertyChange(const Symbol('emailAddress'), this._emailAddress, e.snapshot.val());
    });
    service.dbRef.child("persons/$id/firstName").onValue.listen((e) {
      _firstName = notifyPropertyChange(const Symbol('firstName'), this._firstName, e.snapshot.val());
    });
    service.dbRef.child("persons/$id/lastName").onValue.listen((e) {
      _lastName = notifyPropertyChange(const Symbol('lastName'), this._lastName, e.snapshot.val());
    });
    service.dbRef.child("persons/$id/isAdmin").onValue.listen((e) {
      _isAdmin = notifyPropertyChange(const Symbol('isAdmin'), this._isAdmin, e.snapshot.val());
    });

    competenceIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Competence competence = new Competence.retrieve(record.key, service);
            competences.add(competence);//TODO
          }

          //Something removed
          if (record.isRemove) {
            competences.removeWhere((competence) => competence.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("persons/$id/competenceIds").onChildAdded.listen((e) {
      competenceIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("persons/$id/competenceIds").onChildRemoved.listen((e) {
      competenceIds.remove(e.snapshot.key);
    });

//    subCategoryIds.changes.listen((records) {
//      for (ChangeRecord record in records) {
//        //We don't need to do anything with PropertyChangeRecords.
//        if (record is MapChangeRecord) {
//          //Something added
//          if (record.isInsert) {
//            SubCategory subCategory = new SubCategory.retrieve(record.key, service);
//            subcategories.add(subCategory);//TODO
//          }
//
//          //Something removed
//          if (record.isRemove) {
//            subcategories.removeWhere((subCategory) => subCategory.id == record.key);
//          }
//        }
//      }
//    });
//
//    service.dbRef.child("categories/$id/subCategoryIds").onChildAdded.listen((e) {
//      subCategoryIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
//    });
//
//    service.dbRef.child("categories/$id/subCategoryIds").onChildRemoved.listen((e) {
//      subCategoryIds.remove(e.snapshot.key);
//    });
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

  addCompetence(CompetenceTemplate competenceTemplate){
    Competence competence = new Competence.fromTemplate(competenceTemplate, service);
    service.dbRef.child("persons/$id/competenceIds").update(new Map()..putIfAbsent(competence.id, () => true));
  }

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    id = _json["id"]==null ? null : _json["id"];
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
