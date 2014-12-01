import 'dart:html';
import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'competence_model.dart';
import 'package:core_elements/core_ajax_dart.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";

typedef void ResponseHandler(response, HttpRequest req);

@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published List<Competence> competences;
  @observable bool signedin = false;
  GoogleOAuth2 auth;
  CoreAjax ajaxGetItems;
  CoreAjax ajaxPutItem;
  Map _headers;

  CompetencesService.created() : super.created() {
    competences = new List<Competence>();
  }

  void domReady(){
    ajaxGetItems = shadowRoot.querySelector('#ajaxGetItems');
    ajaxPutItem = shadowRoot.querySelector('#ajaxPutItem');
  }

  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
  }

  List<Competence> ajaxGetItemsResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //print(response['competences']);

    try {
      if (response == null) {
        return null;
      }
    } catch (e) {
      return null;
    }

    competences = toObservable(response['items'].map((s){
        Competence c = new Competence.fromJson(s);
        c.value.service = this;
        return c;
      }).toList());//['items'] was new
    return competences;
  }

  void ajaxPutItemResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    print(response);

    try {
      if (response == null) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map get headers             => _headers;
  set headers(Map headers) {
    _headers = headers;
    print("headersss: $headers");
    ajaxGetItems.headers = headers;
    ajaxPutItem.headers = headers;
  }

  void getItems(){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxGetItems.go();
  }

  void updateItem(Competence competence){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxPutItem.body = JSON.encode(competence.toJson());
    print("body: ${ajaxPutItem.body}");
    ajaxPutItem.go();
  }

  void signedIn(CustomEvent event, dynamic response){
    signedin=true;

    headers = {"Content-type": "application/json",
               "Authorization": "${response['result']['token_type']} ${response['result']['access_token']}"};
    getItems();
  }

  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}