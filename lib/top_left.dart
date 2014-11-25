
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:core_elements/core_ajax_dart.dart';

@CustomTag('top-left')
class TopLeft extends PolymerElement {
  TopLeft.created() : super.created();
  @observable bool signedin = false;
  @observable String accessToken = "";
  @observable String name = "";

  void signedIn(CustomEvent event, dynamic response){
    //print("google-signin-aware-success $response");
    accessToken = response['result']['access_token'];
    //print(accessToken);
    signedin = true;
    /*CoreAjax peopleAjax =shadowRoot.querySelector('#ajax-people');
    print(peopleAjax.url);
    peopleAjax.go();*/
  }

  void signedOut(CustomEvent event, dynamic detail){
    print("google-signin-aware-signed-out $detail");
    signedin = false;
  }

  void parseResponse(CustomEvent event, Map detail, CoreAjax node) {
    var response = detail['response'];
    print(response);

    try {
      if (response == null) {
        //print('returned');
        return null;
      }
    } catch (e) {
      //print('returned');
      return null;
    }

    name = ", "+response['nickname'];
    String email = response['emails'][0]['value'];
    /*competences = toObservable(response
            .map((s) => new Competence.fromJson(s)).toList());*/
  }
}
