@HtmlImport('app_akepot.html')
library akepot.lib.app_akepot;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/login_screen.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/pages/page_home.dart';
import 'package:akepot/pages/page_edit.dart';
import 'package:akepot/pages/page_report.dart';
import 'package:akepot/pages/page_category.dart';
import 'package:akepot/pages/page_join.dart';
import 'package:akepot/pages/page_not_found.dart';
import 'package:polymer_elements/app_route.dart';
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_button.dart';
import 'dart:developer';

@PolymerRegister('app-akepot')
class AppAkepot extends PolymerElement {
  @property bool signedIn = false;
  @property bool readyDom = false;
  @property User user;
  @property dynamic route;
  @property dynamic routeData;
  @property dynamic subroute = {};//needs initialization to work
  @property dynamic subrouteData;
  @property dynamic tail = {};//needs initialization to work
  @property CompetencesService service;
  @Property(observer: 'pageChanged') String page;
  String toplevel;
  String projectHash;
  String selectedCategory;

  IronPages ip;
  IronMeta meta;

  AppAkepot.created() : super.created();

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void ready () {
    set('service', $$('competences-service'));
    print("service: $service");
    meta = $$('iron-meta');
    CompetencesService s = meta.byKey('service');
    print(s);
    ip = $$('iron-pages');
  }

  @Observe('routeData.toplevel')
  void routeToplevelChanged(String toplevel) {
    debugger();
    this.toplevel = toplevel;
    if (toplevel == null || toplevel == ""){
      set('page', 'home');
    } else if (toplevel != 'admin' && toplevel != 'project'){
      set('page', 'not_found');
    }
    print("toplevel: $toplevel");
  }

  @Observe('routeData.projectHash')
  void projectHashChanged(String projectHash) {
    debugger();
    this.projectHash = projectHash;
    print("projectHash: $projectHash");
  }

  @Observe('subrouteData.page')
  void subroutePageChanged(String page) {
    debugger();
    if ((page == null || page == "") && toplevel == 'project'){
      set('page', 'category');
    } else if ((toplevel == 'admin' && page != 'edit' && page != 'report')
                || (toplevel == 'project' && page != 'category' && page != 'join')){
      set('page', 'not_found');
    } else {
      set('page', page);
    }
    print("page: $page");
  }

  @Observe('subrouteData.detail')
  void subrouteDetailChanged(String detail) {
    debugger();
    if(page == "category"){
      this.selectedCategory = detail;
    }
    print("selectedCategory: ${this.selectedCategory}");
  }

  @reflectable
  void pageChanged(String page, String old) {
    debugger();
    // load page import on demand.
    print('pageChanged: '+page);
    //Polymer.importHref('pages/page_' + page + '.html');
  }

  @reflectable
  String computeLoginScreenVisibility(bool signedIn, bool readyDom){
    debugger();
    String defaultClass = "layout vertical center-center fit";
    print("computeLoginScreenVisibility: signedIn: $signedIn, readyDom: $readyDom");
    if (signedIn && readyDom){
      return defaultClass;
    } else {
      return 'show ' + defaultClass;
    }
  }
}
