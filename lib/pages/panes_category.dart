
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:akepot/model/model_project.dart';
import 'package:akepot/model/model_person.dart';
import 'package:akepot/model/model_category.dart';
import 'package:akepot/competences_service.dart';
import 'package:app_router/app_router.dart';

@CustomTag('panes-category')
class PanesCategory extends PolymerElement {

  @observable CompetencesService service;
  @published String projectHash = "";
  @published String selectedCategory;

  PanesCategory.created() : super.created();

  void domReady(){
    service = document.querySelector("#service");
    if(service.signedIn) signedIn(null, null, null);
  }

  void signedIn(Event e, var detail, HtmlElement target){
    Person.exists(service.user.uid, projectHash, service, (exists) {
      if (!exists){
        (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/join");
      }
    });

    if(selectedCategory == "" || selectedCategory == null){
      service.dbRef.child("projects/$projectHash/categoryIds").once("value").then((snapshot) {
            Map val = snapshot.val();
            if(val == null || val.keys.isEmpty){
              return;
            }

            new Category.retrieve(val.keys.first, projectHash, service, true, (Category category) {
              String newSelectedCategory = encodeUriComponent(category.name);
              (document.querySelector('app-router') as AppRouter).go("/project/$projectHash/category/$newSelectedCategory");
            });
      });
    }

    if(service.project != null && service.project.hash == projectHash){
      return;
    }

    service.project = new Project.retrieve(projectHash, service);
  }

  encodeUriComponent(String str) => Uri.encodeComponent(str);
}