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
    //print("created");
    competences = new List<Competence>();
  }

  @override
  void attached(){
    super.attached();
    //var auth = new JsObject(shadowRoot.querySelector('#authenticator')).callMethod('authorize');
    //print("attached");

    //Start listening to REST results from the ajax component.
    //ajax = querySelector('#ajax'); //cannot access shadowRoot so core-ajax-dart needs to be outside of template. -> no, automatic node selection ($['']) does work with core-ajax-dart inside template, but only from the moment of the 'attached' lifecycle callback.
    //$['ajax'].on["core-response"].listen(parseResponse);//using declarative event handler
  }

  /*void domReady(){
    auth = new GoogleOAuth2(
        "71435708886-adrd3d3qumqm1ssedko964621rlku3nj.apps.googleusercontent.com",
        ["https://www.googleapis.com/auth/userinfo.email"],
        tokenLoaded: authenticated,
        autoLogin: false);
    auth.login();
  }*/

  void authenticated(CustomEvent event, var detail) {
    String token = detail['token'];
    Map headers = {"Content-type": "application/json",
               "Authorization": "Bearer $token"};
    print("headersss: $headers");
    //String urlparams={"access_token": token}.toString();
    CoreAjax ajax = shadowRoot.querySelector('#ajax');
    //ajax.withCredentials = true;
    ajax.headers = headers;
    //ajax.params = urlparams;
    ajax.go();
  }

  /*void authenticated(CustomEvent event, var detail) {
    String token = detail['token'];
    headers = {"Content-type": "application/json",
               "Authorization": "Bearer $token"};
    print("headersss: $headers");
    //urlparams={"'access_token'": token}.toString();
    /*CoreAjax ajax = shadowRoot.querySelector('#ajax');
    ajax.withCredentials = true;
    ajax.go();*/

    HttpRequest xhr = new HttpRequest();
    String method = 'GET';

    String url="https://1-dot-akepot-competence-matrix.appspot.com/_ah/api/itemendpoint/v1/item?access_token=$token";

    xhr.open(method, url, async: true);

    xhr.responseType = "json";

    xhr.withCredentials = true;

    this._makeReadyStateHandler(xhr, parseResponse);
    this._setRequestHeaders(xhr, headers);

    xhr.send(null);

    //auth.authenticate(xhr).then((request) => request.send(null));
  }*/

  _makeReadyStateHandler(HttpRequest xhr, ResponseHandler callback) {
    xhr.onReadyStateChange.listen((_) {
      if (xhr.readyState == 4) {
        if (callback != null) callback(xhr.response, xhr);
      }
    });
  }

  _setRequestHeaders(HttpRequest xhr, Map headers) {
    if (headers != null) {
      for (var name in headers.keys) {
        xhr.setRequestHeader(name, headers[name]);
      }
    }
  }

  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(detail);
    //print((detail['xhr'] as HttpRequest).);
    print(event);
    print(node);

  }

  List<Competence> parseResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    //print(response['competences']);

    try {
      if (response == null) {
        //print('returned');
        return null;
      }
    } catch (e) {
      //print('returned');
      return null;
    }

    competences = toObservable(response['items']
            .map((s) => new Competence.fromJson(s)).toList());//['items'] was new
    return competences;
  }

  void signedIn(CustomEvent event, dynamic response){
    //print("google-signin-aware-success");
    signedin=true;
  }

  void signedOut(CustomEvent event, dynamic detail){
    //print("google-signin-aware-signed-out $detail");
    signedin=false;
  }
}