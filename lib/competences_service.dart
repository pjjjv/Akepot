import 'dart:html';
import 'dart:collection';
import 'package:polymer/polymer.dart';
import 'competence_model.dart';
import 'package:core_elements/core_ajax_dart.dart';


@CustomTag('competences-service')
class CompetencesService extends PolymerElement {
  @published List<Competence> competences;
  @observable bool signedin = false;

  CompetencesService.created() : super.created() {
    //print("created");
    competences = new List<Competence>();
  }

  @override
  void attached(){
    super.attached();
    //print("attached");

    //Start listening to REST results from the ajax component.
    //ajax = querySelector('#ajax'); //cannot access shadowRoot so core-ajax-dart needs to be outside of template. -> no, automatic node selection ($['']) does work with core-ajax-dart inside template, but only from the moment of the 'attached' lifecycle callback.
    //$['ajax'].on["core-response"].listen(parseResponse);//using declarative event handler
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

    competences = toObservable(response
            .map((s) => new Competence.fromJson(s)).toList());
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