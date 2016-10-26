@HtmlImport('scaffold_layout.html')
library akepot.lib.layouts.scaffold_layout;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/app_layout/app_drawer_layout/app_drawer_layout.dart';
import 'package:polymer_elements/app_layout/app_drawer/app_drawer.dart';
import 'package:polymer_elements/app_layout/app_header/app_header.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/app_layout/app_header_layout/app_header_layout.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/app_layout/app_scroll_effects/effects/waterfall.dart';
import 'package:akepot/competences_service.dart';
import 'package:akepot/menu/menu_home.dart';
import 'package:akepot/menu/menu_admin.dart';
import 'package:akepot/menu/menu_project.dart';
import 'package:akepot/dropdown_menu.dart';
import 'package:akepot/refresh_spinner.dart';

@PolymerRegister('scaffold-layout')
class ScaffoldLayout extends PolymerElement {
  @property String selected;
  @property String menu;
  @property String projectHash;

  ScaffoldLayout.created() : super.created();

  @reflectable
  bool computeHiddenService(CompetencesService service){
    if (service!=null && service.user!=null && service.user.profile!=null){
      return false;
    } else {
      return true;
    }
  }

  @reflectable
  bool computeHiddenMenuHome(String menu){
    if (menu!=null && menu=="home"){
      return false;
    } else {
      return true;
    }
  }

  @reflectable
  bool computeHiddenMenuProject(String menu){
    if (menu!=null && menu=="project"){
      return false;
    } else {
      return true;
    }
  }

  @reflectable
  bool computeHiddenMenuAdmin(String menu){
    if (menu!=null && menu=="admin"){
      return false;
    } else {
      return true;
    }
  }

}
