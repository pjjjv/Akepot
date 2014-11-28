import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      // 'userList' is the name of the route.
      'projectsHashes': routeCfg(
          // '/users' is the path element shown in the browsers URL bar when this
          // route is active.
          path: '/projects/:projectHash',
          // The tag name for the view to create for this route.
          view: 'project-hash',
          // Use this route when no specific route can be found for the current URL.
          defaultRoute: true,
          // Don't recreate (remove/add) the view element but just pass the
          // updated parameter values to the existing view when the route stays
          // the same as before but some route parameters have changed.
          dontLeaveOnParamChanges: true,
          // When this route is choosen as default route, the view is created but
          // the URL in the browsers URL bar doesn't reflect this.
          // Explicitely `go` to this route updates the URL in the address bar
          // (maybe there is a better way to reach the same result).
          enter: (route) => router.go('projectsHashes', {}))
    });
  }
}