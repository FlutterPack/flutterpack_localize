import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Loads JSON translation files from assets and caches them.
///
/// Example usage:
/// ```dart
/// final loader = FlutterPackLocalizeFileLoader('assets/i18n');
/// final translations = await loader.load(Locale('en'));
/// ```
class FlutterPackLocalizeFileLoader {
  /// The directory containing locale JSON files.
  final String rootDir;

  /// In-memory cache.
  final Map<String, Map<String, dynamic>> _cache = {};

  FlutterPackLocalizeFileLoader(this.rootDir) : assert(rootDir.isNotEmpty);

  /// Loads and caches translations for the given [locale].
  ///
  /// If already loaded, returns cached version.
  Future<Map<String, dynamic>> load(Locale locale) async {
    final code = locale.languageCode;

    if (_cache.containsKey(code)) {
      return _cache[code]!;
    }

    try {
      final filePath = '$rootDir/$code.json';
      final jsonString = await rootBundle.loadString(filePath);
      final parsed = json.decode(jsonString) as Map<String, dynamic>;
      _cache[code] = parsed;
      return parsed;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LocalizeFileLoader: Failed to load $code.json: $e');
      }
      _cache[code] = {};
      return {};
    }
  }
}
