import 'package:flutter/widgets.dart';
import 'flutterpack_localize_utils.dart';

/// Provides access to translations for a specific locale.
///
/// You typically access this using:
/// ```dart
/// Localize.of(context).tr('key')
/// ```
class FlutterPackLocalize {
  /// Active locale.
  final Locale locale;

  /// Cached translations.
  static Map<String, dynamic> _localizedStrings = {};

  FlutterPackLocalize(this.locale);

  /// Access the current Localize instance.
  static FlutterPackLocalize of(BuildContext context) {
    final instance = Localizations.of<FlutterPackLocalize>(
      context,
      FlutterPackLocalize,
    );
    assert(
      instance != null,
      'FlutterPackLocalize.of(context) called but no FlutterPackLocalize found. '
      'Did you add FlutterPackLocalizeConfig.delegate() in localizationsDelegates?',
    );
    return instance!;
  }

  /// Load translations into memory.
  static void loadFromMap(Map<String, dynamic> map) {
    _localizedStrings = map;
  }

  /// Translate a key, with optional placeholders or plural form.
  ///
  /// Example:
  /// ```dart
  /// tr('auth.login')
  /// tr('greeting', params: {'name': 'Alice'})
  /// tr('items', plural: 2)
  /// ```
  String tr(String key, {Map<String, String>? params, int? plural}) {
    final resolved = FlutterPackLocalizeUtils.resolveKey(
      _localizedStrings,
      key,
      plural: plural,
    );
    if (resolved == null) return '**$key**';
    return FlutterPackLocalizeUtils.interpolate(resolved, params);
  }
}
