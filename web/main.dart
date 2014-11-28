import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import 'package:bwu_polymer_routing/module.dart' as brt;
import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart'
    show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import 'package:akepot/route_initializer.dart';
import 'package:bwu_polymer_routing/di.dart';
import 'package:route_hierarchical/client.dart';

void main() {
  // dummy to satisfy the di transformer
  brt.RouteCfg y;
  initPolymer().run(() {
    //(querySelector('#menu_button') as PolymerElement).onClick.listen(openMenu);
    Content contentModel;


    Polymer.onReady.then((_) {
      var content = document.querySelector('#content');
      contentModel = new Content();
      templateBind(content).model = contentModel;
    });
  });

  var router = new Router();
  router.root
    ..addRoute(name: 'project', path: '/projects/:projectHash', enter: showArticle)
    ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
  router.listen();
}

void showHome(RouteEvent e) {
  // nothing to parse from path, since there are no groups
  print("home");
}

void showArticle(RouteEvent e) {
  var projectHash = e.parameters['projectHash'];
  print("project");
  // show article page with loading indicator
  // load article from server, then render article
}

void openMenu(Event e) {
  print("openMenu");
  var dialog = querySelector('#dialog');
  dialog.toggle();
}

// 'with DIContent' applies a mixin that enables this Polymer element to serve
// DI requests for its child elements
class Content extends Observable with DiContext {
  @observable List items = toObservable([]);
  @observable var orderedIndex = "content1";

  @override
  void attached() {

    super.attached();

    // Initialize the DI container.
    // We pass the element it should listen for di request events on
    // and the DI configuration (AppModule).
    initDiContext(this, new ModuleInjector([new AppModule()]));

    // NOTE: If an element is DiContext and DiConsumer at the same time
    // the `<content>` element should be passed to `initDiContext` otherwise
    // the element serves its own DI requests, which would lead ot endless loops.
  }

  void goTo(Event e) {
    print("wentTo");
  }
}

// Register types for DI (dependency injection)
class AppModule extends Module {
  AppModule() : super() {
    // At first install the RoutingModule.
    // usePushState: true/false defines whether only the hash part (after #)
    // should be used for routing (false) or the entire URL (true).
    //
    // Using `usePushState: true` requires server support otherwise resources
    // like CSS files can't be found and a reload of the page will fail.
    // Our example_02 doesn't load any additional ressource therefore it works
    // with `usePushState: true` but you can't just reload the page because
    // the original URL of the page is not available anymore.
    install(new RoutingModule(usePushState: false));

    // After installing the RoutingModule a your custom bindings.
    // The RoutInitializer class contains our custom router configuration.
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}