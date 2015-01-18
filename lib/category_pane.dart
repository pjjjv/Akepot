
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_subcategory.dart';
import 'package:akepot/subcategory_card.dart';
import 'dart:html';
import 'package:core_elements/core_ajax_dart.dart';
import 'dart:math';
import 'dart:convert';

@CustomTag('category-pane')
class CategoryPane extends PolymerElement {
  CategoryPane.created() : super.created();

  @published List<SubCategory> subcategories;
  @observable List<Palette> palettes = [];
  CoreAjax ajaxColourSchemes;

  void domReady() {
    ajaxColourSchemes = shadowRoot.querySelector('#ajax-colour-schemes');
    getColourSchemes();
  }

  void getColourSchemes(){
    Map map = {};
    map['numResults'] = 100;

    if(document.querySelector("#cmdebug") != null){
      ajaxColourSchemes.url = "data/colour_schemes_response.json";
    }
    ajaxColourSchemes.body = JSON.encode(map);
    print("url: ${ajaxColourSchemes.url}, body: ${ajaxColourSchemes.body}");
    ajaxColourSchemes.onCoreResponse.listen(ajaxColourSchemesResponse);
    ajaxColourSchemes.go();
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

    for (SubCategoryCard card in shadowRoot.querySelectorAll('#card')){
      card.palette = palettes[pseudoRandomColor(card.subcategory.name)];
      card.generateBackground();
    }
  }

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