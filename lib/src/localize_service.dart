import 'package:flutter/widgets.dart';
import 'localize_utils.dart';

/// Provides access to translations for a specific locale.
///
/// You typically access this using:
/// ```dart
/// Localize.of(context).tr('key')
/// ```
class Localize {
  /// Active locale.
  final Locale locale;

  /// Cached translations.
  static Map<String, dynamic> _localizedStrings = {};

  Localize(this.locale);

  /// Access the current Localize instance.
  static Localize of(BuildContext context) {
    final instance = Localizations.of<Localize>(context, Localize);
    assert(
      instance != null,
      'Localize.of(context) called but no Localize found. '
      'Did you add LocalizeConfig.delegate() in localizationsDelegates?',
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
    final resolved = LocalizeUtils.resolveKey(
      _localizedStrings,
      key,
      plural: plural,
    );
    if (resolved == null) return '**$key**';
    return LocalizeUtils.interpolate(resolved, params);
  }
}
