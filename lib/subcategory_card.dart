@HtmlImport('subcategory_card.html')
library akepot.lib.subcategory_card;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/single_strength_item.dart';
import 'package:akepot/core_card2.dart';
import 'package:polymer_elements/iron_image.dart';
import 'dart:html';
import 'dart:js';
import 'dart:math';
import 'dart:async';
import 'package:akepot/competences_service.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_meta.dart';

@PolymerRegister('subcategory-card')
class SubCategoryCard extends PolymerElement {
  SubCategoryCard.created() : super.created();

  CompetencesService service;
  @property SubCategory subcategory;
  @property Palette palette;

  void ready() {
    if(service.palettes!=null) palettesLoaded(null, null);
  }

  void attached() {
    service = new IronMeta().byKey('service');
  }

  @reflectable
  void palettesLoaded(Event e, var detail){
    Timer.run(() => changeCards());
  }

  void changeCards(){
    if(palette!=null) return;
    palette = service.palettes[pseudoRandomColor(subcategory.name)];
    generateBackground();
  }

  int pseudoRandomColor(String text){
    int limit = service.palettes.length;
    Random generator = new Random(text.hashCode);
    int random = generator.nextInt(limit);
    return random;
  }

  @reflectable
  void closeDesc(Event e, var detail) {
    for(SingleStrengthItem item in querySelectorAll('single-strength-item')){
      item.closeDesc();
    }
  }

  void generateBackground() {
    if(palette == null){
      return;
    }
    IronImage image = $$('#header');
    if(image.getClientRects().length == 0){
      return;
    }
    Rectangle clientRect = image.getClientRects()[0];

    var trianglifier = new JsObject(context['Trianglify'], [new JsObject.jsify({"bleed": 30,
      "cellsize": 75,
      "x_gradient": new JsObject.jsify(palette.colors),
      //"y_gradient": false,
      "cellpadding": 15,
      "noiseIntensity": 0.2
    })]);
    var pattern = trianglifier.callMethod('generate', [clientRect.width, clientRect.height]);

    image.src = pattern['dataUri'];
  }
}
