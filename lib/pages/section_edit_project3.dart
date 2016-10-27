@HtmlImport('section_edit_project3.html')
library akepot.lib.pages.section_edit_project3;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_project.dart';
import 'dart:html';
import 'package:akepot/core_card3.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:akepot/model/model_role.dart';

@PolymerRegister("section-edit-project3")
class SectionEditProject3 extends PolymerElement {
  SectionEditProject3.created() : super.created() {

  }

  @property Project project;
  @property int page;
  @property int index;

  @reflectable
  void onItemTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "roletap", "data": target.id } );
  }

  @reflectable
  void onCreateButtonTap(Event e, var detail){
    this.fire( "iron-signal", detail: { "name": "addrole" } );
  }

  @reflectable
  void onItemDeleteButtonTap(Event e, var detail){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removerole", "data": target.parent.id } );
  }

  @reflectable
  void onProjectDeleteButtonTap(Event e, var detail){
    e.stopPropagation();
    this.fire( "iron-signal", detail: { "name": "removeproject", "data": target.id } );
  }


  @reflectable
  bool computeHero(int index, int page, Role role){
    return (page == 1 || page == 0) && role.index == index;
  }

  @reflectable
  bool computeCrossFadeDelayed(int index, int page, Role role){
    return page != 0 || role.index != index;
  }
}