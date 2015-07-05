library akepot.model.model_category;

import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/competences_service.dart';
import 'package:firebase/firebase.dart';

/** Not documented yet. */
class Category extends Observable {
  /** Not documented yet. */
  String _description = "";
  String get description => _description;
  void set description(String value) {
    this._description = notifyPropertyChange(const Symbol('description'), this._description, value);

    _changeProperty("categories/$id", new Map()..putIfAbsent("description", () => description));
  }

  /** Not documented yet. */
  @observable String id;

  /** Not documented yet. */
  String _name = "";
  String get name => _name;
  void set name(String value) {
    this._name = notifyPropertyChange(const Symbol('name'), this._name, value);

    _changeProperty("categories/$id", new Map()..putIfAbsent("name", () => name));
  }

  /** Not documented yet. */
  @observable List<SubCategory> subcategories = toObservable([]);
  @observable ObservableMap subCategoryIds = toObservable(new Map());

  @observable CompetencesService service;

  Category.full(this.id, this._name, this._description, this.subcategories);

  Category.newId(this.id);

  Category.emptyDefault() {
    _name = "New Category";
  }

  factory Category.retrieve(String id, CompetencesService service) {
    Category category = toObservable(new Category.newId(id));
    service.dbRef.child("categories/$id").once("value").then((snapshot) {
      Map val = snapshot.val();
      category.fromJson(val);

      if(category != null) {
        category._listen(service);
      } else {
        //New category
        category = toObservable(new Category.newRemote(service));
      }
    });
    return category;
  }

  factory Category.newRemote(CompetencesService service) {
    Category category = toObservable(new Category.emptyDefault());
    Firebase pushRef = service.dbRef.child("categories").push();
    category.id = pushRef.key;
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
    SubCategory subCategory = new SubCategory.newRemote(service);
    service.dbRef.child("categories/$id/subCategoryIds").update(new Map()..putIfAbsent(subCategory.id, () => true));
  }

  removeSubCategory(int index){
    String subCategoryId = subcategories[index].id;
    service.dbRef.child("categories/$id/subCategoryIds/$subCategoryId").remove();
  }

  _listen(CompetencesService service){
    this.service = service;
    service.dbRef.child("categories/$id/name").onValue.listen((e) {
      _name = notifyPropertyChange(const Symbol('name'), this._name, e.snapshot.val());
    });
    service.dbRef.child("categories/$id/description").onValue.listen((e) {
      _description = notifyPropertyChange(const Symbol('description'), this._description, e.snapshot.val());
    });

    subCategoryIds.changes.listen((records) {
      for (ChangeRecord record in records) {
        //We don't need to do anything with PropertyChangeRecords.
        if (record is MapChangeRecord) {
          //Something added
          if (record.isInsert) {
            SubCategory subCategory = new SubCategory.retrieve(record.key, service);
            subcategories.add(subCategory);//TODO
          }

          //Something removed
          if (record.isRemove) {
            subcategories.removeWhere((subCategory) => subCategory.id == record.key);
          }
        }
      }
    });

    service.dbRef.child("categories/$id/subCategoryIds").onChildAdded.listen((e) {
      subCategoryIds.addAll(new Map()..putIfAbsent(e.snapshot.key, () => e.snapshot.val()));
    });

    service.dbRef.child("categories/$id/subCategoryIds").onChildRemoved.listen((e) {
      subCategoryIds.remove(e.snapshot.key);
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
    if (name != null) {
      _json["name"] = name;
    }
    /*if (subcategories != null) {
      _json["subCategories"] = subcategories.map((value) => (value).toJson()).toList();
    }*/
    return _json;
  }
}
