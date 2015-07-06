library akepot.model.model_role;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_competencelevel.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Role extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("roles/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("roles/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<CompetenceLevel> competenceLevels = toObservable([]);
  @observable ObservableMap competenceLevelIds = toObservable(new Map());

  @observable CompetencesService service;

  Role.full(this.id, this._name, this._description, this.competenceLevels);

  Role.newId(this.id);

  Role.emptyDefault() {
    _name = "New Role";
  }

  factory Role.retrieve(String id, CompetencesService service) {
    Role role = toObservable(new Role.newId(id));
    service.dbRef.child("roles/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      role.fromJson(val);

      if(role != null) {
        role._listen(service);
      } else {
        //New role
        role = toObservable(new Role.newRemote(service));
      }
    });
    return role;
  }

  factory Role.newRemote(CompetencesService service) {
    Role role = toObservable(new Role.emptyDefault());
    Firebase pushRef = service.dbRef.child("roles").push();
    role.id = pushRef.key;
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
    service.dbRef.child("roles/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("roles/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
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

  fromJson(Map _json, [bool noId = false]) {
    if (!_json.containsKey("id") && noId == false) {
      throw new Exception("No id.");
    }
    id = _json["id"]==null ? null : _json["id"];
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
    if (name != null) {
      _json["name"] = name;
    }
    /*if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}
