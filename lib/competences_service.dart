@HtmlImport('competences_service.html')
library akepot.lib.competences_service;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'dart:html';
import 'dart:convert';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/iron_request.dart';
import 'package:polymer_elements/firebase_app.dart';
import 'package:polymer_elements/firebase_auth.dart';
import 'dart:developer';
import 'package:firebase3/firebase.dart' as firebase;

typedef void ResponseHandler(response, HttpRequest req);

//const SERVER = "http://localhost:8888/";
const SERVER = "https://shining-heat-1634.firebaseio.com/";
const DEBUG = true;

@PolymerRegister('competences-service')
class CompetencesService extends PolymerElement {
  @Property(notify: true) bool signedIn = false;
  @Property(notify: true) bool readyDom = false;
  @Property(notify: true) User user = new User();
  @property dynamic user2 = {};
  IronAjax ajaxUserinfo;
  Map _headers;
  FirebaseApp fb;
  FirebaseAuth auth;
  firebase.DatabaseReference dbRef;
  List<Category> categories = []; //For names only
  Project project;
  IronAjax ajaxColourSchemes;
  List<Palette> palettes;

  CompetencesService.created() : super.created() {
    firebase.initializeApp(
      apiKey: "AIzaSyByIYqE6-sqzM-Gt_xXWv9MDigJ7krVKm8",
      authDomain: "shining-heat-1634.firebaseapp.com",
      databaseURL: SERVER,
      storageBucket: "shining-heat-1634.appspot.com");
    dbRef = firebase.database().ref('/');
    auth = $$('#auth');
    fb = $$('#firebase-app');
  }

  void ready(){
    ajaxUserinfo = $$('#ajax-people');
    ajaxColourSchemes = $$('#ajax-colour-schemes');
    if($$("#cmdebug") != null){
      ajaxColourSchemes.url = "data/colour_schemes_response.json";//TODO: nodejitsu is gone
    }
    //ajaxColourSchemes.generateRequest();
    set('readyDom', true);
  }

  @reflectable
  void ajaxError(Event e, var detail) {
    if (DEBUG) print(detail.error);
  }

  Map get headers => _headers;
  set headers(Map headers) {
    _headers = headers;
    if (DEBUG) print("headers: $headers");
    ajaxUserinfo.headers = headers;
  }

  @reflectable
  void signInDone(Event e, var response){//TODO: if signin fails: Exception
    if(response==null){
      throw new Exception("Not authorized and response is null.");
    }
    if (DEBUG) print("signinResult: $response");

    headers = {"Content-type": "application/json",
      "Authorization": "Bearer ${(response['credential']['accessToken'] as String)}"};

    //TODO: dbRef was old firebase2 that I use for everything but auth. Here I link through auth.
    //dbRef.authWithOAuthToken("google", (response['credential']['accessToken'] as String));
    var credential = firebase.GoogleAuthProvider.credential((response['credential']['accessToken'] as String));
    // Sign in with credential from the Google user.
    firebase.auth().signInWithCredential(credential).then((authData) {
      if (DEBUG) print("Authenticated successfully 2222222 with payload:" + authData.toString());
    },
    onError:(error) {
      if (DEBUG) print("Auth 2222 failed" + error.toString());
    });

    set('user', new User());
    user.uid = response['user']['uid'];//TODO: use set for subproperties?
    if (user.uid == "" || user.uid == null) {
      if (DEBUG) print("uid empty");
    }

    user.email = response['user']['email'];
    user.nickname = "";
    if(response['user']['displayName'] != null){
      user.nickname = response['user']['displayName'];
    } else if(response['user']['providerData'][0]['displayName'] != null){
      user.nickname = response['user']['providerData'][0]['displayName'];
    }

    getUserinfo();
  }

  void getUserinfo(){
    ajaxUserinfo.generateRequest();
  }

  @reflectable
  void parseUserinfoResponse(Event e, var detail) {
    try {
      if (detail.response == null) {
        return null;
      }
    } catch (exception) {
      return null;
    }

    var resp = convertToDart(detail.response);
    if (DEBUG) print("parseUserinfoResponse: "+resp.toString());

    //user.email = resp['emails'][0]['value'];
    user.nickname = "";
    if(resp['nickname'] != null){
      user.nickname = resp['nickname'];
    } else if(resp['displayName'] != null){
      user.nickname = resp['displayName'];
    }

    user.firstname = resp['name']['givenName'];
    user.lastname = resp['name']['familyName'];


    int PROFILE_IMAGE_SIZE = 75;
    int COVER_IMAGE_SIZE = 315;

    if(resp['image'] != null){
      user.profile = (resp['image']['url'] as String).replaceFirst(new RegExp('/(.+)\?sz=\d\d/'), "\$1?sz=" + PROFILE_IMAGE_SIZE.toString());
    }

    /*if(resp['cover'] != null){
      user.cover = (resp['cover']['coverPhoto']['url'] as String).replaceFirst(new RegExp('/\/s\d{3}-/'), "/s" + COVER_IMAGE_SIZE.toString() + "-");
    }*/

    set('signedIn', true);

    this.fire( "iron-signal", detail: { "name": "signedin" } );
  }

  @reflectable
  void signOutDone(Event e, var detail){
    set('signedIn', false);
  }

// Retrieves colour palettes using the Colourlovers API, creating a new Palette
// for each
  @reflectable
  void ajaxColourSchemesResponse(Event e, var detail) {
    if (DEBUG) print(
        "ajaxColourSchemesResponse: " + JSON.encode(convertToDart(detail.response)).toString());

    try {
      if (detail.response == null) {
        return; //TODO: error
      }
    } catch (exception) {
      return;
    }

    palettes = [];
    for (Map palette in (convertToDart(detail.response) as List)) {
      palettes.add(new Palette.fromJson(palette));
    }

    this.fire("iron-signal", detail: { "name": "palettesloaded"});
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
