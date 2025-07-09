import 'package:flutter/widgets.dart';
import 'flutterpack_localize_service.dart';

/// Flutter LocalizationsDelegate for injecting translations into the widget tree.
///
/// This is used by MaterialApp:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     FlutterPackLocalizeConfig.delegate(),
///   ],
/// )
/// ```
class FlutterPackLocalizeDelegate
    extends LocalizationsDelegate<FlutterPackLocalize> {
  /// The locale to use.
  final Locale? newLocale;

  /// The translations to load.
  final Map<String, dynamic>? translations;

  const FlutterPackLocalizeDelegate({this.newLocale, this.translations});

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<FlutterPackLocalize> load(Locale locale) async {
    FlutterPackLocalize.loadFromMap(translations ?? {});
    return FlutterPackLocalize(newLocale ?? locale);
  }

  @override
  bool shouldReload(covariant FlutterPackLocalizeDelegate old) {
    return old.translations != translations || old.newLocale != newLocale;
  }
}
