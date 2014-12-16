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
  @observable bool signedin = false;
  @published String hash;
  @observable String userid;
  @published String newlink = "";
  @published bool loadproject;
  CoreAjax ajaxUserinfo;
  CoreAjax ajaxGetProject;
  CoreAjax ajaxUpdateCompetence;
  CoreAjax ajaxNewProject;
  CoreAjax ajaxNewPerson;
  Map _headers;

  String email;
  String firstname;
  String lastname;
  String nickname;

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
    print(detail);
  }

  @reflectable
  List<Category> ajaxGetProjectResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
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
  void ajaxUpdateCompetenceResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
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
    ajaxUserinfo.headers = headers;
    ajaxGetProject.headers = headers;
    ajaxUpdateCompetence.headers = headers;
    ajaxNewProject.headers = headers;
    ajaxNewPerson.headers = headers;
  }

  @reflectable
  void ajaxNewProjectResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("response: $response");

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    String teamId = response['teams'][0]['id']['id'];

    addAdminPerson(teamId);
  }

  @reflectable
  void ajaxNewPersonResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("response: $response");

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    newlink = window.location.protocol + "//" + window.location.host + window.location.pathname + context['MoreRouting'].callMethod('urlFor', ['projectRoute', new JsObject.jsify({'projectHash': '$hash'})]);
    print("New project link would be: $newlink");


    PaperActionDialog dialog = document.querySelector('#dialog');

    PaperButton goButton = document.querySelector('#go-button');
    goButton.onClick.listen(onGoButtonClick);

    dialog.toggle();
  }

  void onGoButtonClick(Event e){
    context['MoreRouting'].callMethod('navigateTo', ['projectRoute', new JsObject.jsify({'projectHash': '$hash'})]);
  }

  void getProject(){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxGetProject.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/project/$hash/$userid";
    print("url: ${ajaxGetProject.url}");
    ajaxGetProject.onCoreResponse.listen(ajaxGetProjectResponse);
    ajaxGetProject.go();//TODO: can be disabled to exclude expensive rest queries
  }

  void updateCompetence(Competence competence){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxUpdateCompetence.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/competencevalue/$hash/$userid";
    ajaxUpdateCompetence.body = JSON.encode(competence.toJson());
    print("url: ${ajaxUpdateCompetence.url}, body: ${ajaxUpdateCompetence.body}");
    ajaxUpdateCompetence.onCoreResponse.listen(ajaxUpdateCompetenceResponse);
    ajaxUpdateCompetence.go();
  }

  void newProject(Project project){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxNewProject.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/project/$hash";
    ajaxNewProject.body = JSON.encode(project.toJson());
    print("url: ${ajaxNewProject.url}, body: ${ajaxNewProject.body}");
    ajaxNewProject.onCoreResponse.listen(ajaxNewProjectResponse);
    ajaxNewProject.go();
  }

  void addAdminPerson(String teamId){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    Map map = {};
    map['nickName'] = nickname;
    map['firstName'] = firstname;
    map['lastName'] = lastname;
    map['emailAddress'] = {};
    map['emailAddress']['email'] = email;
    map['token'] = userid;

    ajaxNewPerson.url = "https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/akepot/v1/addUser/$hash/$teamId";
    ajaxNewPerson.body = JSON.encode(map);
    print("url: ${ajaxNewPerson.url}, body: ${ajaxNewPerson.body}");
    ajaxNewPerson.onCoreResponse.listen(ajaxNewPersonResponse);
    ajaxNewPerson.go();
  }

  @reflectable
  void signedIn(CustomEvent event, Map response){
    signedin = true;
    if(response==null || response['result']==null){
      throw new Exception("Not authorized and repsonse is null.");
    }
    print("signinResult: $response");

    headers = {"Content-type": "application/json",
               "Authorization": "${((response['result'] as Map)['token_type'] as String)} ${((response['result'] as Map)['access_token'] as String)}"};

    getUserinfo();
  }

  void getUserinfo(){
    if(!signedin){
      throw new Exception("Not signed in.");
    }
    ajaxUserinfo.onCoreResponse.listen(parseUserinfoResponse);
    ajaxUserinfo.go();
  }

  void parseUserinfoResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    //print(response);

    try {
      if (response == null) {
        //print('returned');
        return null;
      }
    } catch (e) {
      //print('returned');
      return null;
    }

    //name = ", "+response['nickname'];
    email = response['emails'][0]['value'];
    userid = response['id'];
    nickname = response['nickname'];
    firstname = response['name']['givenName'];
    lastname = response['name']['familyName'];

    if (userid == "" || userid == null) {
      print("userid empty");
    }
    print("loadproject: $loadproject");
    if(loadproject == true){
      getProject();
    }
  }

  @reflectable
  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}