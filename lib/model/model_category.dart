library akepot.model.model_category;

import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase3/firebase.dart';
import 'package:observe/observe.dart';

/** Not documented yet. */
class Category extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("projects/$projectHash/categories/$id", new Map()..putIfAbsent("description", () => description));
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

    _changeProperty("projects/$projectHash/categories/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<SubCategory> subcategories = toObservable([]);
  @observable ObservableMap subCategoryIds = toObservable(new Map());

  @observable CompetencesService service;

  Category.full(this.id, String this.projectHash, this._name, this._description, this.subcategories);

  Category.newId(this.id, String this.projectHash);

  Category.emptyDefault() {
    _name = "New Category";
  }

  factory Category.retrieve(String id, String projectHash, CompetencesService service, [bool onlyName = false, dynamic callback(Category category)]) {
    Category category = toObservable(new Category.newId(id, projectHash));
    service.dbRef.child("projects/$projectHash/categories/$id").once("value").then((event) {
      Map val = event.snapshot.val();
      if(val != null){
        category.fromJson(val);
      } else {
        category = null;
      }

      if(category != null) {
        category._listen(service, onlyName);
      } else {
        if (onlyName) {
          category = toObservable(new Category.newId(id, projectHash));
          return;
        }
        //New category
        category = toObservable(new Category.newRemote(projectHash, service));
      }

      if (callback != null){
        callback(category);
      }
    });
    return category;
  }

  factory Category.newRemote(String projectHash, CompetencesService service) {
    Category category = toObservable(new Category.emptyDefault());
    ThenableReference pushRef = service.dbRef.child("projects/$projectHash/categories").push();
    category.id = pushRef.key;
    category.projectHash = projectHash;
    pushRef.set(category.toJson()).then((error) {
      if(error != null) {
        //
      } else {
        category._listen(service);
      }
    });
    return category;
  }

  toString() => id + ": " + name;//TODO

  addSubCategory(){
    SubCategory subCategory = new SubCategory.newRemote(projectHash, service);
    service.dbRef.child("projects/$projectHash/categories/$id/subCategoryIds").update(new Map()..putIfAbsent(subCategory.id, () => true));
  }

  removeSubCategory(int index){
    String subCategoryId = subcategories[index].id;
    service.dbRef.child("projects/$projectHash/categories/$id/subCategoryIds/$subCategoryId").remove();
  }

  _listen(CompetencesService service, [bool onlyName = false]){
    this.service = service;
    service.dbRef.child("projects/$projectHash/categories/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });

    if (!onlyName){
      service.dbRef.child("projects/$projectHash/categories/$id/description").onValue.listen((e) {
        _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
      });

      subCategoryIds.changes.listen((records) {
        for (ChangeRecord record in records) {
          //We don't need to do anything with PropertyChangeRecords.
          if (record is MapChangeRecord) {
            //Something added
            if (record.isInsert) {
              SubCategory subCategory = new SubCategory.retrieve(record.key, projectHash, service);
              subcategories.add(subCategory);//TODO
            }

            //Something removed
            if (record.isRemove) {
              subcategories.removeWhere((subCategory) => subCategory.id == record.key);
            }
          }
        }
      });

      service.dbRef.child("projects/$projectHash/categories/$id/subCategoryIds").onChildAdded.listen((e) {
        subCategoryIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
      });

      service.dbRef.child("projects/$projectHash/categories/$id/subCategoryIds").onChildRemoved.listen((e) {
        subCategoryIds.remove(e.snapshot.key);
      });
    }
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
      name = "Unknown Category";
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
