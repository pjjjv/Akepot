library akepot.model.model_project;

import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_team.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_role.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';
import 'package:observe/observe.dart';
import 'dart:developer';

/** Not documented yet. */
class Project extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/$hash", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String hash;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("projects/$hash", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<Category> categories = toObservable([]);
  @observable ObservableMap categoryIds = toObservable(new Map());

  /** Not documented yet. */
  @observable List<Team> teams = toObservable([]);
  @observable ObservableMap teamIds = toObservable(new Map());

  /** Not documented yet. */
  @observable List<Role> roles = toObservable([]);
  @observable ObservableMap roleIds = toObservable(new Map());

  /** Not documented yet. */
  @observable List<Person> admins = toObservable([]);
  @observable ObservableMap adminIds = toObservable(new Map());

  @observable CompetencesService service;

  Project.full(this.hash, this._name, this._description, this.categories, this.teams, this.roles, this.admins);

  Project.newHash(this.hash);

  Project.emptyDefault() {
    _name = "New Project";
  }

  factory Project.retrieve(String hash, CompetencesService service, [dynamic callback(Project project)]) {
    Project project = toObservable(new Project.newHash(hash));
    service.dbRef.child("projects/$hash").once("value").then((snapshot) {
      Map val = snapshot.val();
      if(val == null){
        return;
      }
      project.fromJson(val);

      if(project != null) {
        project._listen(service);
      } else {
        //New project
        //project = toObservable(new Project.newRemote(service));
      }

      if (callback != null){
        callback(project);
      }
    });
    return project;
  }

  factory Project.newRemote(CompetencesService service) {
    Project project = toObservable(new Project.emptyDefault());
    Firebase pushRef = service.dbRef.child("projects").push();
    project.hash = pushRef.key;
    project.service = service;
    pushRef.set(project.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        project._listen(service);
      }
    });
    return project;
  }

  toString() => name;

  addCategory(){
    Category category = new Category.newRemote(hash, service);
    service.dbRef.child("projects/$hash/categoryIds").update(new Map()..putIfAbsent(category.id, () => true));
  }

  removeCategory(int index){
    String categoryId = categories[index].id;
    service.dbRef.child("projects/$hash/categoryIds/$categoryId").remove();
  }

  Team addTeam(){
    Team team = new Team.newRemote(hash, service);
    service.dbRef.child("projects/$hash/teamIds").update(new Map()..putIfAbsent(team.id, () => true));
    return team;
  }

  removeTeam(int index){
    String teamId = teams[index].id;
    service.dbRef.child("projects/$hash/teamIds/$teamId").remove();
  }

  addNewAdmin(String uid){
    Person admin = new Person.newRemote(service, uid, hash);
    admin.isAdmin = true;
    addAdmin(admin);
  }

  addAdmin(Person admin){
    service.dbRef.child("projects/$hash/adminIds").update(new Map()..putIfAbsent(admin.id, () => true));
  }

  removeAdmin(int index){
    String adminId = admins[index].id;
    service.dbRef.child("projects/$hash/adminIds/$adminId").remove();
  }

  addRole(){
    Role role = new Role.newRemote(hash, service);
    service.dbRef.child("projects/$hash/roleIds").update(new Map()..putIfAbsent(role.id, () => true));
  }

  removeRole(int index){
    String roleId = roles[index].id;
    service.dbRef.child("projects/$hash/roleIds/$roleId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("projects/$hash/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("projects/$hash/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    categoryIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Category category = new Category.retrieve(record.key, hash, service);
            categories.add(category);//TODO
          }

          //Something removed
          if (record.isRemove) {
            categories.removeWhere((category) => category.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$hash/categoryIds").onChildAdded.listen((e) {
      categoryIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$hash/categoryIds").onChildRemoved.listen((e) {
      categoryIds.remove(e.snapshot.key);
    });

    teamIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Team team = new Team.retrieve(record.key, hash, service);
            teams.add(team);//TODO
          }

          //Something removed
          if (record.isRemove) {
            teams.removeWhere((team) => team.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$hash/teamIds").onChildAdded.listen((e) {
      teamIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$hash/teamIds").onChildRemoved.listen((e) {
      teamIds.remove(e.snapshot.key);
    });

    roleIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Role role = new Role.retrieve(record.key, hash, service);
            roles.add(role);//TODO
          }

          //Something removed
          if (record.isRemove) {
            roles.removeWhere((role) => role.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$hash/roleIds").onChildAdded.listen((e) {
      roleIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$hash/roleIds").onChildRemoved.listen((e) {
      roleIds.remove(e.snapshot.key);
    });

    adminIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            Person admin = new Person.retrieve(record.key, hash, service);
            admins.add(admin);//TODO
          }

          //Something removed
          if (record.isRemove) {
            admins.removeWhere((admin) => admin.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("projects/$hash/adminIds").onChildAdded.listen((e) {
      adminIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("projects/$hash/adminIds").onChildRemoved.listen((e) {
      adminIds.remove(e.snapshot.key);
    });
  }

  _changeProperty(String child, var value){
    if(service != null) {
      service.dbRef.child(child).update(value);
    }
  }

  Person findPerson(String uid){
    for (Team team in teams){
      return team.persons.firstWhere((Person person) => person.id == uid);
    }
    return null;
  }

  static void isAdmin(String hash, String uid, CompetencesService service, dynamic callback(bool isAdmin)) {
    if(hash==null || hash=="") return;
    service.dbRef.child("projects/$hash/adminIds/$uid").onValue.listen((e) {
      if (e.snapshot.val() != null && e.snapshot.val() != ""){
        callback(e.snapshot.val());
      } else {
        callback(false);
      }
    });
  }

  static void getName(String hash, CompetencesService service, dynamic callback(String name)) {
    if(hash==null || hash=="") return;
    service.dbRef.child("projects/$hash/name").onValue.listen((e) {
      if (e.snapshot.val() != null && e.snapshot.val() != ""){
        callback("${e.snapshot.val()}");
      } else {
        callback(hash);
      }
    });
  }

  static void getCategoryNames(String hash, CompetencesService service, dynamic callback(List<Category> categories)) {
    if(hash==null || hash=="") return;
    Project project = toObservable(new Project.newHash(hash));
    service.dbRef.child("projects/$hash").once("value").then((snapshot) {
      Map val = snapshot.val();
      if(val == null){
        return;
      }
      project.fromJson(val);

      if(project != null) {
        project.categoryIds.changes.listen((records) {
          for (ChangeRecord record in records) {
            //We don't need to do anything with PropertyChangeRecords.
            if (record is MapChangeRecord) {
              //Something added
              if (record.isInsert) {
                Category category = new Category.retrieve(record.key, hash, service, true);
                project.categories.add(category);//TODO
              }

              //Something removed
              if (record.isRemove) {
                project. categories.removeWhere((category) => category.id == record.key);
              }
            }
          }
        });

        service.dbRef.child("projects/$hash/categoryIds").onChildAdded.listen((e) {
          project.categoryIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
        });

        service.dbRef.child("projects/$hash/categoryIds").onChildRemoved.listen((e) {
          project.categoryIds.remove(e.snapshot.key);
        });

        callback(project.categories);
      } else {
        callback([]);
      }
    });
  }

  fromJson(Map _json, [bool noHash = false]) {//TODO: use JsonObject: https://www.dartlang.org/articles/json-web-service/#introducing-jsonobject, or even better Dartson (see test-arrays-binding Firebase branch), when they work with polymer
    if (!_json.containsKey("hash") && noHash == false) {
      throw new Exception("No hash.");
    }
    hash = _json["hash"]==null ? null : _json["hash"];
    if (_json.containsKey("name")) {
      name = _json["name"];
    } else {
      name = "Unknown Project";
    }
    if (_json.containsKey("description")) {
      description = _json["description"];
    } else {
      description = "-";
    }
  }

  Map<String, dynamic> toJson() {
    var _json = new Map<String, dynamic>();
    if (description != null) {
      _json["description"] = description;
    }
    if (hash != null) {
      _json["hash"] = hash;
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}
