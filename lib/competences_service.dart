import 'dart:html';
import 'package:polymer/polymer.dart';
import 'competence_model.dart';
import 'package:core_elements/core_ajax_dart.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";

typedef void ResponseHandler(response, HttpRequest req);

@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published List<Competence> competences;
  @observable bool signedin = false;
  GoogleOAuth2 auth;

  CompetencesService.created() : super.created() {
    competences = new List<Competence>();
  }

  void authenticated(CustomEvent event, Token token) {
    if (token.expired){
      throw new Exception("Token expired");
    }
    Map headers = {"Content-type": "application/json",
               "Authorization": "${token.type} ${token.data}"};
    //print("headersss: $headers");
    CoreAjax ajax = shadowRoot.querySelector('#ajax');
    ajax.headers = headers;
    ajax.go();
  }

  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
  }

  List<Competence> parseResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //print(response['competences']);

    try {
      if (response == null) {
        return null;
      }
    } catch (e) {
      return null;
    }

    competences = toObservable(response['items']
            .map((s) => new Competence.fromJson(s)).toList());//['items'] was new
    return competences;
  }

  void signedIn(CustomEvent event, dynamic response){
    signedin=true;
  }

  void signedOut(CustomEvent event, dynamic detail){
    signedin=false;
  }
}