@HtmlImport('subbcategory_card.html')
library akepot.lib.subbcategory_card;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/single_strength_item.dart';
import 'package:polymer_elements/iron_image.dart';
import 'dart:html';
import 'dart:js';
import 'dart:math';
import 'dart:async';
import 'package:akepot/competences_service.dart';

@PolymerRegister('subcategory-card')
class SubCategoryCard extends PolymerElement {
  SubCategoryCard.created() : super.created();

  CompetencesService service;
  @property SubCategory subcategory;
  @property Palette palette;

  void domReady() {
    service = document.querySelector("#service");
    if(service.palettes!=null) palettesLoaded(null, null, null);
  }

  void palettesLoaded(Event e, var detail, HtmlElement target){
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

  void closeDesc(Event e) {
    for(SingleStrengthItem item in shadowRoot.querySelectorAll('single-strength-item')){
      item.closeDesc();
    }
  }

  void generateBackground() {
    if(palette == null){
      return;
    }
    IronImage image = shadowRoot.querySelector('#header');
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