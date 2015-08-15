library competence_service;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'model/model_project.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/model/model_project.dart';
import 'package:core_elements/core_ajax_dart.dart';
import 'package:firebase/firebase.dart';

typedef void ResponseHandler(response, HttpRequest req);

//const SERVER = "http://localhost:8888/";
const SERVER = "https://shining-heat-1634.firebaseio.com/";
const DEBUG = true;

@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published bool signedIn = false;
  @published bool readyDom = false;
  @published User user = new User();
  CoreAjax ajaxUserinfo;
  Map _headers;
  Firebase dbRef;
  @observable List<Category> categories = [];//For names only
  @observable Project project;
  CoreAjax ajaxColourSchemes;
  @observable List<Palette> palettes;

  CompetencesService.created() : super.created() {
    dbRef = new Firebase(SERVER);
  }

  void domReady(){
    ajaxUserinfo = shadowRoot.querySelector('#ajax-people');
    ajaxColourSchemes = shadowRoot.querySelector('#ajax-colour-schemes');
    if(document.querySelector("#cmdebug") != null){
      ajaxColourSchemes.url = "data/colour_schemes_response.json";
    }
    readyDom = true;
  }

  @reflectable
  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    if (DEBUG) print(event.detail);
  }

  Map get headers             => _headers;
  set headers(Map headers) {
    _headers = headers;
    if (DEBUG) print("headers: $headers");
    ajaxUserinfo.headers = headers;
  }


  @reflectable
  void signInDone(CustomEvent event, Map response){//TODO: if signin fails: Exception
    if(response==null){
      throw new Exception("Not authorized and repsonse is null.");
    }
    if (DEBUG) print("signinResult: $response");

    headers = {"Content-type": "application/json",
               "Authorization": "Bearer ${(response['google']['accessToken'] as String)}"};

    user = new User();
    user.uid = response['uid'];
    if (user.uid == "" || user.uid == null) {
      if (DEBUG) print("uid empty");
    }

    getUserinfo();
  }

  void getUserinfo(){
    ajaxUserinfo.go();
  }

  void parseUserinfoResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = event.detail['response'];
    if (DEBUG) print("parseUserinfoResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return null;
      }
    } catch (e) {
      return null;
    }

    user.email = response['emails'][0]['value'];
    user.nickname = "";
    if(response['nickname'] != null){
      user.nickname = response['nickname'];
    } else if(response['displayName'] != null){
      user.nickname = response['displayName'];
    }

    user.firstname = response['name']['givenName'];
    user.lastname = response['name']['familyName'];


    int PROFILE_IMAGE_SIZE = 75;
    int COVER_IMAGE_SIZE = 315;

    if(response['image'] != null){
      user.profile = (response['image']['url'] as String).replaceFirst(new RegExp('/(.+)\?sz=\d\d/'), "\$1?sz=" + PROFILE_IMAGE_SIZE.toString());
    }

    if(response['cover'] != null){
      user.cover = (response['cover']['coverPhoto']['url'] as String).replaceFirst(new RegExp('/\/s\d{3}-/'), "/s" + COVER_IMAGE_SIZE.toString() + "-");
    }

    signedIn = true;

    this.fire( "core-signal", detail: { "name": "signedin" } );
  }

  @reflectable
  void signOutDone(CustomEvent event, dynamic detail){
    signedIn=false;
  }

// Retrieves colour palettes using the Colourlovers API, creating a new Palette
// for each
  @reflectable
  void ajaxColourSchemesResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    if (DEBUG) print("ajaxColourSchemesResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    palettes = [];
    for (Map palette in (response as List)) {
      palettes.add(new Palette.fromJson(palette));
    }

    this.fire( "core-signal", detail: { "name": "palettesloaded" } );
  }
}

class User extends Observable {
  @observable String email = "";
  @observable String uid = "";
  @observable String nickname = "";
  @observable String firstname = "";
  @observable String lastname = "";
  @observable var profile;
  @observable var cover;
}

// Class representing a single colour palette made up of multiple colours
// Colours are simply hex strings
class Palette extends Observable {
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