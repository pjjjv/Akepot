@HtmlImport('app_akepot.html')
library akepot.lib.app_akepot;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/login_screen.dart';
import 'package:akepot/competences_service.dart';

@PolymerRegister('app-akepot')
class AppAkepot extends PolymerElement {
  @property bool signedIn;
  @property bool readyDom;
  @property User user;
  @property CompetencesService service;

  AppAkepot.created() : super.created();

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  void ready () {
    service = $$('#service');
  }
}
