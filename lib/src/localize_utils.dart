/// Utility functions to resolve and interpolate translation keys.
class LocalizeUtils {
  /// Resolves a nested key with optional pluralization.
  ///
  /// Example:
  /// ```dart
  /// final map = {
  ///   'items': {
  ///     'zero': 'No items',
  ///     'one': 'One item',
  ///     'other': '{count} items',
  ///   }
  /// };
  /// resolveKey(map, 'items', plural: 2); // => '2 items'
  /// ```
  static String? resolveKey(
    Map<String, dynamic> map,
    String key, {
    int? plural,
  }) {
    final parts = key.split('.');
    dynamic value = map;

    for (final part in parts) {
      if (value is Map<String, dynamic> && value.containsKey(part)) {
        value = value[part];
      } else {
        return null;
      }
    }

    if (plural != null && value is Map<String, dynamic>) {
      if (plural == 0 && value.containsKey('zero')) return value['zero'];
      if (plural == 1 && value.containsKey('one')) return value['one'];
      if (value.containsKey('other')) {
        return value['other']!.replaceAll('{count}', '$plural');
      }
      return null;
    }

    if (value is String) return value;
    return null;
  }

  /// Replaces `{key}` placeholders with values from [params].
  static String interpolate(String? template, Map<String, String>? params) {
    if (template == null) return '';
    if (params == null || params.isEmpty) return template;

    return template.replaceAllMapped(
      RegExp(r'\{(\w+)\}'),
      (m) => params[m.group(1)!] ?? m.group(0)!,
    );
  }
}
