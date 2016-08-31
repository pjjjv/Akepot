@HtmlImport('competences_service.html')
library akepot.lib.competences_service;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'dart:convert';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_project.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_request.dart';
//import 'package:polymer_elements/firebase_app.dart';
import 'package:firebase/firebase.dart';

typedef void ResponseHandler(response, HttpRequest req);

//const SERVER = "http://localhost:8888/";
const SERVER = "https://shining-heat-1634.firebaseio.com/";
const DEBUG = true;

@PolymerRegister('competences-service')
class CompetencesService extends PolymerElement {
  @property bool signedIn = false;
  @property bool readyDom = false;
  @property User user = new User();
  IronAjax ajaxUserinfo;
  Map _headers;
  Firebase dbRef;
  List<Category> categories = []; //For names only
  Project project;
  IronAjax ajaxColourSchemes;
  List<Palette> palettes;

  CompetencesService.created() : super.created() {
    dbRef = new Firebase(SERVER);

    // Initialize Firebase
    /*var config = {
      apiKey: "AIzaSyByIYqE6-sqzM-Gt_xXWv9MDigJ7krVKm8",
      authDomain: "shining-heat-1634.firebaseapp.com",
      databaseURL: "https://shining-heat-1634.firebaseio.com",
      storageBucket: "shining-heat-1634.appspot.com",
    };

    firebase.initializeApp(config);

    var rootRef = firebase.database().ref();*/

    /*FirebaseApp firebaseApp = $$('firebase-app');
    dbRef = firebaseApp.app(0).database().ref;*/
  }

  @reflectable
  void ajaxError(CustomEventWrapper event, {request: IronRequest, error: dynamic}) {
    if (DEBUG) print(event.detail);
  }

  void ready(){
    ajaxUserinfo = $$('#ajax-people');
    ajaxColourSchemes = $$('#ajax-colour-schemes');
    if(document.querySelector("#cmdebug") != null){
      ajaxColourSchemes.url = "data/colour_schemes_response.json";
    }
    readyDom = true;
  }
}

class User {
  String email = "";
  String uid = "";
  String nickname = "";
  String firstname = "";
  String lastname = "";
  var profile;
  var cover;
}

// Class representing a single colour palette made up of multiple colours
// Colours are simply hex strings
class Palette {
  final String name;
  final List<String> colors;

  Palette(this.name, this.colors);

  toString() => name;

  factory Palette.fromJson(Map _json) {
    String name = "Palette";
    List<String> colors = [];

    if (_json.containsKey("title")) {
      name = _json["title"];
    }
    if (_json.containsKey("colors")) {
      colors = _json["colors"].map((color) => "#"+color).toList();
    }

    Palette palette = new Palette(name, colors);
    return palette;
  }
}
