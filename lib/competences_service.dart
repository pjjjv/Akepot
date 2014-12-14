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
  CoreAjax ajaxGetProject;
  CoreAjax ajaxUpdateCompetence;
  Map _headers;

  CompetencesService.created() : super.created() {
    categories = new List<Category>();
  }

  void domReady(){
    ajaxGetProject = shadowRoot.querySelector('#ajaxGetProject');
    ajaxUpdateCompetence = shadowRoot.querySelector('#ajaxUpdateCompetence');
  }

  @reflectable
  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
  }

  @reflectable
  List<Category> ajaxGetProjectResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    print("response: $response");

    try {
      if (response == null || response['categories'] == null) {
        return [];//TODO: empty list
      }
    } catch (e) {
      return null;
    }



    categories = toObservable(response['categories'].map((s){
      Category category = new Category.fromJson(s);
      for (SubCategory subcategory in category.subcategories){
        for (Competence competence in subcategory.competences){
          competence.value.service = this;
        }
      }
      return category;
      }).toList());//['items'] was new
    return categories;
  }

  @reflectable
  void ajaxUpdateCompetenceResponse(CustomEvent event, Map detail, CoreAjax node) {
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
    ajaxGetProject.headers = headers;
    ajaxUpdateCompetence.headers = headers;
  }

  void getProject(){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    //ajaxGetProject.go();//TODO
  }

  void updateCompetence(Competence competence){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxUpdateCompetence.body = JSON.encode(competence.toJson());
    print("body: ${ajaxUpdateCompetence.body}");
    ajaxUpdateCompetence.go();
  }

  @reflectable
  void signedIn(CustomEvent event, Map response){
    signedin = true;
    if(response==null || response['result']==null){
      throw new Exception("Not authorized and repsonse is null.");
    }
    headers = {"Content-type": "application/json",
               "Authorization": "${((response['result'] as Map)['token_type'] as String)} ${((response['result'] as Map)['access_token'] as String)}"};
    getProject();
  }

  @reflectable
  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}