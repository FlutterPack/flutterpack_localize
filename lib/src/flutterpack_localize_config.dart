import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutterpack_localize_delegate.dart';
import 'flutterpack_localize_service.dart';
import 'flutterpack_localize_file_loader.dart';

/// Manages the current locale, persistence, and lazy loading of translations.
///
/// When locale changes via [changeLocale] or [changeLocaleWithPreference],
/// translations are automatically loaded and cached.
///
/// Example usage:
/// ```dart
/// await FlutterPackLocalizeConfig.init(
///   Locale('en'),
///   persistLanguage: true,
///   fileLoader: FlutterPackLocalizeFileLoader('assets/i18n'),
/// );
/// ```
class FlutterPackLocalizeConfig {
  /// Currently active locale wrapped in a [ValueNotifier].
  static late ValueNotifier<Locale> currentLocale;

  static bool _persistLanguage = false;

  static const String _storageKey = 'localize_selected_locale';

  /// Responsible for loading JSON translation files lazily.
  static FlutterPackLocalizeFileLoader? _fileLoader;

  /// Cache for the last loaded translation map.
  static Map<String, dynamic> _currentTranslations = {};

  /// Notifies listeners when translations change.
  static final translationsNotifier = ValueNotifier<Map<String, dynamic>>({});

  /// Initializes the localization system.
  ///
  /// - [defaultLocale]: the locale to use initially if no saved locale found.
  /// - [persistLanguage]: whether to persist selected locale across app launches.
  /// - [fileLoader]: loader used to load locale JSON files lazily.
  static Future<void> init(
    Locale defaultLocale, {
    bool persistLanguage = false,
    FlutterPackLocalizeFileLoader? fileLoader,
  }) async {
    _persistLanguage = persistLanguage;
    _fileLoader = fileLoader;

    final savedLocale = await _loadSavedLocale();
    currentLocale = ValueNotifier(savedLocale ?? defaultLocale);

    if (_fileLoader != null) {
      await _loadTranslations(currentLocale.value);
    }
  }

  /// Changes the current locale.
  ///
  /// Respects the global [_persistLanguage] setting for saving the choice.
  static Future<void> changeLocale(Locale locale) async {
    await _setLocale(locale, persist: _persistLanguage);
  }

  /// Changes the current locale specifying whether to persist this selection.
  ///
  /// Use this when you want per-user/session control over persistence.
  static Future<void> changeLocaleWithPreference(
    Locale locale, {
    required bool persist,
  }) async {
    await _setLocale(locale, persist: persist);
  }

  /// Internal method to update locale and optionally persist it.
  ///
  /// Automatically loads translations for the new locale.
  static Future<void> _setLocale(Locale locale, {required bool persist}) async {
    currentLocale.value = locale;

    if (persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, locale.languageCode);
    }

    if (_fileLoader != null) {
      await _loadTranslations(locale);
    }
  }

  /// Loads translations for the given [locale] using the configured [_fileLoader].
  ///
  /// Updates [_currentTranslations] cache and notifies listeners.
  static Future<void> _loadTranslations(Locale locale) async {
    assert(
      _fileLoader != null,
      'File loader must be set before loading translations.',
    );
    final loaded = await _fileLoader!.load(locale);
    _currentTranslations = loaded;
    translationsNotifier.value = loaded;
  }

  /// Returns the currently loaded translations.
  static Map<String, dynamic> get currentTranslations => _currentTranslations;

  /// Returns a [LocalizationsDelegate] that can be added to MaterialApp.
  ///
  /// Example:
  /// ```dart
  /// localizationsDelegates: [
  ///   LocalizeConfig.delegate(),
  /// ]
  /// ```
  static LocalizationsDelegate<FlutterPackLocalize> delegate() {
    return FlutterPackLocalizeDelegate(
      newLocale: currentLocale.value,
      translations: _currentTranslations,
    );
  }

  /// Attempts to load the saved locale from persistent storage.
  static Future<Locale?> _loadSavedLocale() async {
    if (!_persistLanguage) return null;
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    return code != null ? Locale(code) : null;
  }
}
