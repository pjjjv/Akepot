library competence_model;

import 'package:polymer/polymer.dart';

class Competence extends Observable {
  final int id;
  final String title;
  final String desc;
  final int value;

  Competence(this.id, this.title, this.desc, this.value);

  factory Competence.fromJson(Map json) {
    return new Competence(int.parse(json['id']), json['title'], json['desc'],
        int.parse(json['value']));
  }

  toString() => title;
}