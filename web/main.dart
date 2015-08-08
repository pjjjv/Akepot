import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import 'package:akepot/competences_service.dart';

const DEBUG = true;

main() => initPolymer();

@initMethod
realMain() {
  Content contentModel;

  Polymer.onReady.then((_) {
    var content = document.querySelector('#content');
    contentModel = new Content();
    templateBind(content).model = contentModel;

    setAkepotTransitionSpeed(350);

    new AppCache(window.applicationCache);
  });
}

class Content extends Observable {
  @observable bool signedIn;
  @observable bool readyDom;
  @observable User user;
  @observable CompetencesService service;

  static const int MIN_SPLASH_TIME = 1000;
  static const Duration SPLASH_TIMEOUT =  const Duration(milliseconds: MIN_SPLASH_TIME);

  Content () {
    service = document.querySelector('#service');
  }
}

void setAkepotTransitionSpeed(int timeInMs){
  /*CoreStyle.g.transitions.duration = timeInMs + 'ms';
  CoreStyle.g.transitions.scaleDelay = CoreStyle.g.transitions.duration;*/

  /*context['CoreStyle']['g']['transitions']['duration'] = timeInMs.toString() + 'ms';
  context['CoreStyle']['g']['transitions']['scaleDelay'] = timeInMs.toString() + 'ms';
  context['CoreStyle']['g']['transitions']['xfadeDuration'] = timeInMs.toString() + 'ms';
  context['CoreStyle']['g']['transitions']['xfadeDelay'] = timeInMs.toString() + 'ms';*/

}

class AppCache {
  ApplicationCache appCache;

  AppCache(this.appCache) {
    // Set up handlers to log all of the cache events or errors.
    appCache.onCached.listen(onCachedEvent);
    appCache.onError.listen(onCacheError);

    // Set up a more interesting handler to swap in the new app when ready.
    appCache.onUpdateReady.listen((e) => updateReady());
  }

  void updateReady() {
    if (appCache.status == ApplicationCache.UPDATEREADY) {
      // The browser downloaded a new app cache. Alert the user and swap it in
      // to get the new hotness.
      appCache.swapCache();

      if (window.confirm('A new version of this site is available. Reload?')) {
        window.location.reload();
      }
    }
  }

  void onCachedEvent(Event e) {
    window.alert("Finished downloading into cache. This web app can now be used offline.");
    if (DEBUG) print('Cache event: ${e}');
  }

  void onCacheError(Event e) {
    // For the sake of this sample alert the reader that an error has occurred.
    // Of course we would *never* do it this way in real life.
    window.alert("Oh no! A cache error occurred: ${e}");
    if (DEBUG) print('Cache error: ${e}');
  }
}
