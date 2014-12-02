import 'dart:html';
import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'model/model_category.dart';
import 'model/model_subcategory.dart';
import 'model/model_competence.dart';
import 'package:core_elements/core_ajax_dart.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";

typedef void ResponseHandler(response, HttpRequest req);

@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published List<Category> categories;
  @observable bool signedin = false;
  GoogleOAuth2 auth;
  CoreAjax ajaxGetCategories;
  CoreAjax ajaxPutItem;
  Map _headers;

  CompetencesService.created() : super.created() {
    categories = new List<Category>();
  }

  void domReady(){
    ajaxGetCategories = shadowRoot.querySelector('#ajaxGetCategories');
    ajaxPutItem = shadowRoot.querySelector('#ajaxPutItem');
  }

  @reflectable
  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
  }

  @reflectable
  List<Category> ajaxGetCategoriesResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //print(response['competences']);

    try {
      if (response == null || response['items'] == null) {
        return [];//TODO: empty list
      }
    } catch (e) {
      return null;
    }

    categories = toObservable(response['items'].map((s){
      Category category = new Category.fromJson(s);
      for (SubCategory subcategory in category.subcategories){
        for (Competence competence in subcategory.items){
          competence.value.service = this;
        }
      }
      return category;
      }).toList());//['items'] was new
    return categories;
  }

  @reflectable
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
    ajaxGetCategories.headers = headers;
    ajaxPutItem.headers = headers;
  }

  void getCategories(){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxGetCategories.go();
  }

  void updateItem(Competence competence){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxPutItem.body = JSON.encode(competence.toJson());
    print("body: ${ajaxPutItem.body}");
    ajaxPutItem.go();
  }

  @reflectable
  void signedIn(CustomEvent event, Map response){
    signedin = true;
    if(response==null || response['result']==null){
      throw new Exception("Not authorized and repsonse is null.");
    }
    headers = {"Content-type": "application/json",
               "Authorization": "${((response['result'] as Map)['token_type'] as String)} ${((response['result'] as Map)['access_token'] as String)}"};
    getCategories();
  }

  @reflectable
  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}