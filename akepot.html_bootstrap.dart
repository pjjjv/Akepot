library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:core_elements/core_toolbar.dart' as i0;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_media_query.dart' as i1;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_selection.dart' as i2;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_selector.dart' as i3;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_drawer_panel.dart' as i4;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_header_panel.dart' as i5;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_meta.dart' as i6;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_iconset.dart' as i7;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_icon.dart' as i8;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_iconset_svg.dart' as i9;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_icon_button.dart' as i10;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_scaffold.dart' as i11;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_menu.dart' as i12;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_item.dart' as i13;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_collapse.dart' as i14;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_submenu.dart' as i15;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_field.dart' as i16;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_input.dart' as i17;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_animated_pages.dart' as i18;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_image.dart' as i19;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_focusable.dart' as i20;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_ripple.dart' as i21;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_shadow.dart' as i22;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_button_base.dart' as i23;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_button.dart' as i24;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_item.dart' as i25;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_style.dart' as i26;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_input_decorator.dart' as i27;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_input.dart' as i28;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_autogrow_textarea.dart' as i29;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_transition.dart' as i30;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_key_helper.dart' as i31;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_overlay_layer.dart' as i32;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_overlay.dart' as i33;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_transition_css.dart' as i34;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_dialog_base.dart' as i35;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_dialog.dart' as i36;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_action_dialog.dart' as i37;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_dialog_transition.dart' as i38;
import 'package:polymer/src/build/log_injector.dart';
import 'package:paper_elements/paper_fab.dart' as i39;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/strength_button.dart' as i40;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/strength_button_slider.dart' as i41;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_animation.dart' as i42;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_animation_group.dart' as i43;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/single_strength_item.dart' as i44;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/core_card2.dart' as i45;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/subcategory_card.dart' as i46;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/category_pane.dart' as i47;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_shared_lib.dart' as i48;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_signals.dart' as i49;
import 'package:polymer/src/build/log_injector.dart';
import 'package:google_signin_dart/google_signin_dart.dart' as i50;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_xhr_dart.dart' as i51;
import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_ajax_dart.dart' as i52;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/top_left.dart' as i53;
import 'package:polymer/src/build/log_injector.dart';
import 'package:akepot/competences_service.dart' as i54;
import 'package:polymer/src/build/log_injector.dart';
import 'main.dart' as i55;
import 'package:polymer/src/build/log_injector.dart';
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:akepot/strength_button.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
import 'package:akepot/strength_button_slider.dart' as smoke_3;
import 'package:akepot/single_strength_item.dart' as smoke_4;
import 'package:akepot/core_card2.dart' as smoke_5;
import 'package:akepot/subcategory_card.dart' as smoke_6;
import 'package:akepot/model/model_subcategory.dart' as smoke_7;
import 'package:akepot/category_pane.dart' as smoke_8;
import 'package:core_elements/core_xhr_dart.dart' as smoke_9;
import 'package:core_elements/core_ajax_dart.dart' as smoke_10;
import 'package:akepot/top_left.dart' as smoke_11;
import 'package:akepot/competences_service.dart' as smoke_12;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #accessToken: (o) => o.accessToken,
        #adminRoute: (o) => o.adminRoute,
        #ajaxError: (o) => o.ajaxError,
        #auto: (o) => o.auto,
        #autoChanged: (o) => o.autoChanged,
        #body: (o) => o.body,
        #bodyChanged: (o) => o.bodyChanged,
        #categories: (o) => o.categories,
        #categoriesAsJson: (o) => o.categoriesAsJson,
        #category: (o) => o.category,
        #competence: (o) => o.competence,
        #competences: (o) => o.competences,
        #contentType: (o) => o.contentType,
        #desc: (o) => o.desc,
        #description: (o) => o.description,
        #error: (o) => o.error,
        #finishToggleDesc: (o) => o.finishToggleDesc,
        #flipBack: (o) => o.flipBack,
        #goTo: (o) => o.goTo,
        #goTo2: (o) => o.goTo2,
        #handleAs: (o) => o.handleAs,
        #hash: (o) => o.hash,
        #headers: (o) => o.headers,
        #heading: (o) => o.heading,
        #id: (o) => o.id,
        #label: (o) => o.label,
        #loading: (o) => o.loading,
        #max: (o) => o.max,
        #method: (o) => o.method,
        #name: (o) => o.name,
        #newlink: (o) => o.newlink,
        #newuser: (o) => o.newuser,
        #number: (o) => o.number,
        #params: (o) => o.params,
        #paramsChanged: (o) => o.paramsChanged,
        #parseResponse: (o) => o.parseResponse,
        #progress: (o) => o.progress,
        #project: (o) => o.project,
        #projectHash: (o) => o.projectHash,
        #projectRoute: (o) => o.projectRoute,
        #rating: (o) => o.rating,
        #response: (o) => o.response,
        #select: (o) => o.select,
        #selected: (o) => o.selected,
        #selectedSection: (o) => o.selectedSection,
        #signedIn: (o) => o.signedIn,
        #signedOut: (o) => o.signedOut,
        #signedin: (o) => o.signedin,
        #subcategories: (o) => o.subcategories,
        #subcategory: (o) => o.subcategory,
        #teamsAsJson: (o) => o.teamsAsJson,
        #title: (o) => o.title,
        #toArray: (o) => o.toArray,
        #toggleDesc: (o) => o.toggleDesc,
        #toggleOtherDescs: (o) => o.toggleOtherDescs,
        #url: (o) => o.url,
        #urlChanged: (o) => o.urlChanged,
        #userid: (o) => o.userid,
        #value: (o) => o.value,
        #withCredentials: (o) => o.withCredentials,
      },
      setters: {
        #accessToken: (o, v) { o.accessToken = v; },
        #adminRoute: (o, v) { o.adminRoute = v; },
        #auto: (o, v) { o.auto = v; },
        #body: (o, v) { o.body = v; },
        #categories: (o, v) { o.categories = v; },
        #categoriesAsJson: (o, v) { o.categoriesAsJson = v; },
        #contentType: (o, v) { o.contentType = v; },
        #desc: (o, v) { o.desc = v; },
        #error: (o, v) { o.error = v; },
        #handleAs: (o, v) { o.handleAs = v; },
        #hash: (o, v) { o.hash = v; },
        #headers: (o, v) { o.headers = v; },
        #label: (o, v) { o.label = v; },
        #loading: (o, v) { o.loading = v; },
        #max: (o, v) { o.max = v; },
        #method: (o, v) { o.method = v; },
        #name: (o, v) { o.name = v; },
        #newlink: (o, v) { o.newlink = v; },
        #newuser: (o, v) { o.newuser = v; },
        #number: (o, v) { o.number = v; },
        #params: (o, v) { o.params = v; },
        #progress: (o, v) { o.progress = v; },
        #projectHash: (o, v) { o.projectHash = v; },
        #projectRoute: (o, v) { o.projectRoute = v; },
        #rating: (o, v) { o.rating = v; },
        #response: (o, v) { o.response = v; },
        #selected: (o, v) { o.selected = v; },
        #selectedSection: (o, v) { o.selectedSection = v; },
        #signedin: (o, v) { o.signedin = v; },
        #subcategories: (o, v) { o.subcategories = v; },
        #subcategory: (o, v) { o.subcategory = v; },
        #teamsAsJson: (o, v) { o.teamsAsJson = v; },
        #title: (o, v) { o.title = v; },
        #url: (o, v) { o.url = v; },
        #userid: (o, v) { o.userid = v; },
        #value: (o, v) { o.value = v; },
        #withCredentials: (o, v) { o.withCredentials = v; },
      },
      parents: {
        smoke_8.CategoryPane: _M0,
        smoke_12.CompetencesService: _M0,
        smoke_5.CoreCard2: smoke_1.PolymerElement,
        smoke_4.SingleStrengthItem: _M0,
        smoke_0.StrengthButton: _M0,
        smoke_3.StrengthButtonSlider: _M0,
        smoke_6.SubCategoryCard: _M0,
        smoke_11.TopLeft: _M0,
        smoke_10.CoreAjax: _M0,
        smoke_9.CoreXhr: smoke_1.PolymerElement,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_8.CategoryPane: {
          #subcategories: const Declaration(#subcategories, List, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_12.CompetencesService: {
          #categories: const Declaration(#categories, List, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #hash: const Declaration(#hash, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #newlink: const Declaration(#newlink, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #newuser: const Declaration(#newuser, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #signedin: const Declaration(#signedin, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #userid: const Declaration(#userid, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
        smoke_5.CoreCard2: {},
        smoke_4.SingleStrengthItem: {
          #desc: const Declaration(#desc, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #number: const Declaration(#number, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #title: const Declaration(#title, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_0.StrengthButton: {
          #number: const Declaration(#number, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #selected: const Declaration(#selected, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_3.StrengthButtonSlider: {
          #max: const Declaration(#max, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #selected: const Declaration(#selected, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_6.SubCategoryCard: {
          #subcategory: const Declaration(#subcategory, smoke_7.SubCategory, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
        smoke_11.TopLeft: {
          #accessToken: const Declaration(#accessToken, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #name: const Declaration(#name, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #signedin: const Declaration(#signedin, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
        smoke_10.CoreAjax: {
          #auto: const Declaration(#auto, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #autoChanged: const Declaration(#autoChanged, Function, kind: METHOD),
          #body: const Declaration(#body, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #bodyChanged: const Declaration(#bodyChanged, Function, kind: METHOD),
          #contentType: const Declaration(#contentType, String),
          #error: const Declaration(#error, dynamic, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #handleAs: const Declaration(#handleAs, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #headers: const Declaration(#headers, Map, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #loading: const Declaration(#loading, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #method: const Declaration(#method, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #params: const Declaration(#params, dynamic, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #paramsChanged: const Declaration(#paramsChanged, Function, kind: METHOD),
          #progress: const Declaration(#progress, smoke_10.CoreAjaxProgress, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #response: const Declaration(#response, dynamic, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #url: const Declaration(#url, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #urlChanged: const Declaration(#urlChanged, Function, kind: METHOD),
          #withCredentials: const Declaration(#withCredentials, bool),
        },
        smoke_9.CoreXhr: {},
      },
      names: {
        #accessToken: r'accessToken',
        #adminRoute: r'adminRoute',
        #ajaxError: r'ajaxError',
        #auto: r'auto',
        #autoChanged: r'autoChanged',
        #body: r'body',
        #bodyChanged: r'bodyChanged',
        #categories: r'categories',
        #categoriesAsJson: r'categoriesAsJson',
        #category: r'category',
        #competence: r'competence',
        #competences: r'competences',
        #contentType: r'contentType',
        #desc: r'desc',
        #description: r'description',
        #error: r'error',
        #finishToggleDesc: r'finishToggleDesc',
        #flipBack: r'flipBack',
        #goTo: r'goTo',
        #goTo2: r'goTo2',
        #handleAs: r'handleAs',
        #hash: r'hash',
        #headers: r'headers',
        #heading: r'heading',
        #id: r'id',
        #label: r'label',
        #loading: r'loading',
        #max: r'max',
        #method: r'method',
        #name: r'name',
        #newlink: r'newlink',
        #newuser: r'newuser',
        #number: r'number',
        #params: r'params',
        #paramsChanged: r'paramsChanged',
        #parseResponse: r'parseResponse',
        #progress: r'progress',
        #project: r'project',
        #projectHash: r'projectHash',
        #projectRoute: r'projectRoute',
        #rating: r'rating',
        #response: r'response',
        #select: r'select',
        #selected: r'selected',
        #selectedSection: r'selectedSection',
        #signedIn: r'signedIn',
        #signedOut: r'signedOut',
        #signedin: r'signedin',
        #subcategories: r'subcategories',
        #subcategory: r'subcategory',
        #teamsAsJson: r'teamsAsJson',
        #title: r'title',
        #toArray: r'toArray',
        #toggleDesc: r'toggleDesc',
        #toggleOtherDescs: r'toggleOtherDescs',
        #url: r'url',
        #urlChanged: r'urlChanged',
        #userid: r'userid',
        #value: r'value',
        #withCredentials: r'withCredentials',
      }));
  new LogInjector().injectLogsFromUrl('akepot.html._buildLogs');
  configureForDeployment([
      i0.upgradeCoreToolbar,
      i1.upgradeCoreMediaQuery,
      i2.upgradeCoreSelection,
      i3.upgradeCoreSelector,
      i4.upgradeCoreDrawerPanel,
      i5.upgradeCoreHeaderPanel,
      i6.upgradeCoreMeta,
      i7.upgradeCoreIconset,
      i8.upgradeCoreIcon,
      i9.upgradeCoreIconsetSvg,
      i10.upgradeCoreIconButton,
      i11.upgradeCoreScaffold,
      i12.upgradeCoreMenu,
      i13.upgradeCoreItem,
      i14.upgradeCoreCollapse,
      i15.upgradeCoreSubmenu,
      i16.upgradeCoreField,
      i17.upgradeCoreInput,
      i18.upgradeCoreAnimatedPages,
      i19.upgradeCoreImage,
      i21.upgradePaperRipple,
      i22.upgradePaperShadow,
      i23.upgradePaperButtonBase,
      i24.upgradePaperButton,
      i25.upgradePaperItem,
      i26.upgradeCoreStyle,
      i27.upgradePaperInputDecorator,
      i28.upgradePaperInput,
      i29.upgradePaperAutogrowTextarea,
      i30.upgradeCoreTransition,
      i31.upgradeCoreKeyHelper,
      i32.upgradeCoreOverlayLayer,
      i33.upgradeCoreOverlay,
      i34.upgradeCoreTransitionCss,
      i35.upgradePaperDialogBase,
      i36.upgradePaperDialog,
      i37.upgradePaperActionDialog,
      i38.upgradePaperDialogTransition,
      i39.upgradePaperFab,
      () => Polymer.register('strength-button', i40.StrengthButton),
      () => Polymer.register('strength-button-slider', i41.StrengthButtonSlider),
      i42.upgradeCoreAnimation,
      i42.upgradeCoreAnimationKeyframe,
      i42.upgradeCoreAnimationProp,
      i43.upgradeCoreAnimationGroup,
      () => Polymer.register('single-strength-item', i44.SingleStrengthItem),
      () => Polymer.register('core-card2', i45.CoreCard2),
      () => Polymer.register('subcategory-card', i46.SubCategoryCard),
      () => Polymer.register('category-pane', i47.CategoryPane),
      i48.upgradeCoreSharedLib,
      i49.upgradeCoreSignals,
      i50.upgradeGoogleSignin,
      i50.upgradeGoogleSigninAware,
      () => Polymer.register('core-xhr-dart', i51.CoreXhr),
      () => Polymer.register('core-ajax-dart', i52.CoreAjax),
      () => Polymer.register('top-left', i53.TopLeft),
      () => Polymer.register('competences-service', i54.CompetencesService),
    ]);
  i55.main();
}
