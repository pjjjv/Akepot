import 'package:polymer/builder.dart';

void main(List<String> args) {
  build(entryPoints: ['web/akepot.html'],
        options: parseOptions(args));
  lint(entryPoints: ['web/akepot.html'],
        options: parseOptions(args));
}