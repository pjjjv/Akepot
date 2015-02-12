import 'dart:html';
import 'package:polymer/polymer.dart';
import 'dart:convert';
import 'dart:js';
import 'model/model_category.dart';
import 'model/model_subcategory.dart';
import 'model/model_competence.dart';
import 'model/model_project.dart';
import 'package:core_elements/core_ajax_dart.dart';
import 'package:paper_elements/paper_action_dialog.dart';
import 'package:paper_elements/paper_button.dart';

typedef void ResponseHandler(response, HttpRequest req);

@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published List<Category> categories;
  @published bool signedin = false;
  @published String hash;
  @published String newlink = "";
  @published bool newuser = false;
  CoreAjax ajaxUserinfo;
  CoreAjax ajaxGetProject;
  CoreAjax ajaxUpdateCompetence;
  CoreAjax ajaxNewProject;
  CoreAjax ajaxNewPerson;
  Map _headers;

  @published User user = new User();

  CompetencesService.created() : super.created() {
    categories = new List<Category>();
  }

  void domReady(){
    ajaxUserinfo = shadowRoot.querySelector('#ajax-people');
    ajaxGetProject = shadowRoot.querySelector('#ajaxGetProject');
    ajaxUpdateCompetence = shadowRoot.querySelector('#ajaxUpdateCompetence');
    ajaxNewProject = shadowRoot.querySelector('#ajaxNewProject');
    ajaxNewPerson = shadowRoot.querySelector('#ajaxNewPerson');
  }

  @reflectable
  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(event.detail);
  }

  @reflectable
  void ajaxGetProjectError(CustomEvent event/*, Map detail, CoreAjax node*/) {
    ajaxError(event, null, null);
    var response = event.detail['response'];

    if (response == "404: Not Found"){
      print("API broken?"); //TODO
    }
    if ((response as String).startsWith("404: {")){//(response[404]['error']['code'] == 404 && response[404]['error']['message'] == "userPerson not found"){
      newuser = true;
    }
    if ((response as String).startsWith("503: {")){//(response[503]['error']['code'] == 503){
      print("project does not exist?"); //TODO
    }
  }

  @reflectable
  List<Category> ajaxGetProjectResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxGetProjectResponse: "+JSON.encode(response).toString());

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
      }).toList());
    return categories;
  }

  @reflectable
  void ajaxUpdateCompetenceResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxUpdateCompetenceResponse: "+JSON.encode(response).toString());

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
    ajaxUserinfo.headers = headers;
    ajaxGetProject.headers = headers;
    ajaxUpdateCompetence.headers = headers;
    ajaxNewProject.headers = headers;
    ajaxNewPerson.headers = headers;
  }

  @reflectable
  void ajaxNewPersonResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxNewPersonResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    getProject(hash);
  }

  void getProject(String thishash){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxGetProject.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/project/$thishash/${user.userid}";
    if(document.querySelector("#cmdebug") != null){
      ajaxGetProject.url = "data/get_project_response.json";
      //ajaxGetProject.url = "data/get_project_error_new_user_response.json"; //new user
    }
    print("url: ${ajaxGetProject.url}");
    ajaxGetProject.onCoreResponse.first.then(ajaxGetProjectResponse);
    ajaxGetProject.onCoreError.first.then(ajaxGetProjectError);
    ajaxGetProject.go();//TODO: can be disabled to exclude expensive rest queries
  }

  void updateCompetence(Competence competence){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxUpdateCompetence.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/competencevalue/$hash/${user.userid}";
    if(document.querySelector("#cmdebug") != null){
      ajaxUpdateCompetence.url = "data/update_competence_response.json";
      return;//don't PUT
    }
    ajaxUpdateCompetence.body = JSON.encode(competence.toJson());
    print("url: ${ajaxUpdateCompetence.url}, body: ${ajaxUpdateCompetence.body}");
    ajaxUpdateCompetence.onCoreResponse.first.then(ajaxUpdateCompetenceResponse);
    ajaxUpdateCompetence.go();
  }

  void newPerson(String teamId, String thishash){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    Map map = {};
    map['nickName'] = user.nickname;
    map['firstName'] = user.firstname;
    map['lastName'] = user.lastname;
    map['emailAddress'] = {};
    map['emailAddress']['email'] = user.email;
    map['token'] = user.userid;

    ajaxNewPerson.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/addUser/$thishash/$teamId";
    if(document.querySelector("#cmdebug") != null){
      ajaxNewPerson.url = "data/new_person_response.json";
    }
    ajaxNewPerson.body = JSON.encode(map);
    print("url: ${ajaxNewPerson.url}, body: ${ajaxNewPerson.body}");
    ajaxNewPerson.onCoreResponse.first.then(ajaxNewPersonResponse);
    ajaxNewPerson.go();
  }

  @reflectable
  void signedIn(CustomEvent event, Map response){//TODO: if signin fails: Exception: Uncaught Error: type 'JsObject' is not a subtype of type 'Map' of 'response'.
    if(response==null || response['result']==null){
      throw new Exception("Not authorized and repsonse is null.");
    }
    print("signinResult: $response");

    headers = {"Content-type": "application/json",
               "Authorization": "${((response['result'] as Map)['token_type'] as String)} ${((response['result'] as Map)['access_token'] as String)}"};

    getUserinfo();
  }

  void getUserinfo(){
    ajaxUserinfo.onCoreResponse.first.then(parseUserinfoResponse);
    /*if(document.querySelector("#cmdebug") != null){
      ajaxUserinfo.url = "data/userinfo_response.json";
    }*/
    ajaxUserinfo.go();
  }

  void parseUserinfoResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("parseUserinfoResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        //print('returned');
        return null;
      }
    } catch (e) {
      //print('returned');
      return null;
    }

    user = new User();

    //name = ", "+response['nickname'];
    user.email = response['emails'][0]['value'];
    user.userid = response['id'];
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

    if (user.userid == "" || user.userid == null) {
      print("userid empty");
    }
    signedin = true;
  }

  @reflectable
  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}

class User extends Observable {
  @observable String email = "";
  @observable String userid = "";
  @observable String nickname = "";
  @observable String firstname = "";
  @observable String lastname = "";
  @observable var profile;
  @observable var cover;
}