import 'package:flutter/widgets.dart';
import 'localize_service.dart';

/// Convenience function for quickly translating strings.
///
/// Example:
/// ```dart
/// Text(tr(context, 'auth.login'))
/// Text(tr(context, 'greeting', params: {'name': 'Alice'}))
/// ```
String tr(
  BuildContext context,
  String key, {
  Map<String, String>? params,
  int? plural,
}) {
  return Localize.of(context).tr(key, params: params, plural: plural);
}
