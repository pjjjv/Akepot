@HtmlImport('app_akepot.html')
library akepot.lib.app_akepot;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/login_screen.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/pages/page_home.dart';
import 'package:akepot/pages/page_edit.dart';
import 'package:akepot/pages/page_not_found.dart';
import 'package:polymer_elements/app_route.dart';
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/iron_meta.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_button.dart';

@PolymerRegister('app-akepot')
class AppAkepot extends PolymerElement {
  @property bool signedIn = false;
  @property bool readyDom = false;
  @property User user;
  @property dynamic route;
  @property dynamic routeData;
  @property dynamic subroute = {};//needs initialization to work
  @property CompetencesService service;
  @Property(observer: 'pageChanged') String page;

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

  @Observe('routeData.page')
  void routePageChanged(String page) {
    if (page == null || page == ""){
      set('page', 'home');
    }
    set('page', page);
    print(page);
  }

  @reflectable
  void pageChanged(String page, String old) {
    // load page import on demand.
    print('pageChanged: '+page);
    //Polymer.importHref('pages/page_' + page + '.html');
  }

  @reflectable
  String computeLoginScreenVisibility(bool signedIn, bool readyDom){
    String defaultClass = "layout vertical center-center fit";
    print("computeLoginScreenVisibility: signedIn: $signedIn, readyDom: $readyDom");
    if (signedIn && readyDom){
      return defaultClass;
    } else {
      return 'show ' + defaultClass;
    }
  }
}
