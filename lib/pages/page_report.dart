@HtmlImport('page_report.html')
library akepot.lib.pages.page_report;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:akepot/layouts/scaffold_layout.dart';
import 'package:akepot/pages/pane_report.dart';
import 'package:akepot/menu/title_page.dart';

@PolymerRegister('page-report')
class PageReport extends PolymerElement {

  PageReport.created() : super.created();

  @Property(notify: true) String projectHash;

}
