import 'package:flutter/widgets.dart';
import 'localize_service.dart';

/// Flutter LocalizationsDelegate for injecting translations into the widget tree.
///
/// This is used by MaterialApp:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     LocalizeConfig.delegate(),
///   ],
/// )
/// ```
class LocalizeDelegate extends LocalizationsDelegate<Localize> {
  /// The locale to use.
  final Locale? newLocale;

  /// The translations to load.
  final Map<String, dynamic>? translations;

  const LocalizeDelegate({this.newLocale, this.translations});

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<Localize> load(Locale locale) async {
    Localize.loadFromMap(translations ?? {});
    return Localize(newLocale ?? locale);
  }

  @override
  bool shouldReload(covariant LocalizeDelegate old) => false;
}
