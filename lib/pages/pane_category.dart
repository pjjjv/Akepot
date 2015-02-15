
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/subcategory_card.dart';
import 'dart:html';
import 'package:core_elements/core_ajax_dart.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

@CustomTag('pane-category')
class PaneCategory extends PolymerElement {
  PaneCategory.created() : super.created();

  @published List<SubCategory> subcategories;
  @observable List<Palette> palettes = [];
  CoreAjax ajaxColourSchemes;

  void domReady() {
    ajaxColourSchemes = shadowRoot.querySelector('#ajax-colour-schemes');
    if(document.querySelector("#cmdebug") != null){
      ajaxColourSchemes.url = "data/colour_schemes_response.json";
    }
  }


  @reflectable
  void ajaxError(CustomEvent event, Map detail, CoreAjax node) {
    print(event.detail);
  }

// Retrieves colour palettes using the Colourlovers API, creating a new Palette
// for each
  @reflectable
  void ajaxColourSchemesResponse(CustomEvent event/*, Map detail, CoreAjax node*/) {
    var response = event.detail['response'];
    print("ajaxColourSchemesResponse: "+JSON.encode(response).toString());

    try {
      if (response == null) {
        return;//TODO: error
      }
    } catch (e) {
      return;
    }

    for (Map palette in (response as List)) {
      palettes.add(new Palette.fromJson(palette));
    }

    changeCards();
    //startupForColor();
  }

  void changeCards(){
    var a = shadowRoot.querySelectorAll('#card');
    for (SubCategoryCard card in shadowRoot.querySelector('ordered-columns').shadowRoot.querySelectorAll('#card')){//TODO: improve ordered-columns so this is not needed
      card.palette = palettes[pseudoRandomColor(card.subcategory.name)];
      card.generateBackground();
    }
  }

  /*static const Duration TIMEOUT =  const Duration(milliseconds: 2000);

  void startupForColor () {
    print(TIMEOUT);
    new Timer(TIMEOUT, completeStartupForColor);
  }

  void completeStartupForColor () {
    Element orderedColumns = shadowRoot.querySelector('ordered-columns');
    var c = orderedColumns.shadowRoot.querySelectorAll('subcategory-card');//table, tbody, tr, td


    var a = shadowRoot.querySelectorAll('subcategory-card');
    //var aa = b.querySelectorAll('subcategory-card');
    if(false && shadowRoot.querySelectorAll('#card').isEmpty){
      startupForColor();
      return;
    }
    changeCards();
  }*/

  int pseudoRandomColor(String text){
    int limit = palettes.length;
    Random generator = new Random(text.hashCode);
    int random = generator.nextInt(limit);
    return random;
  }
}

// Class representing a single colour palette made up of multiple colours
// Colours are simply hex strings
class Palette extends Observable {
  final String name;
  final List<String> colors;

  Palette(this.name, this.colors);

  toString() => name;

  factory Palette.fromJson(Map _json) {
    String name = "Palette";
    List<String> colors = [];

    if (_json.containsKey("title")) {
      name = _json["title"];
    }
    if (_json.containsKey("colors")) {
      colors = _json["colors"].map((color) => "#"+color).toList();
    }

    Palette palette = new Palette(name, colors);
    return palette;
  }
}