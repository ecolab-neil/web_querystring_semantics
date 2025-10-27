import 'uri_extensions.dart';

extension StringExtensions on String {
  bool toBoolFromQuery({bool defaultValue = false}) {
    final value = UriExtensions.currentUrl
        .getQueryParameter(this)
        ?.toLowerCase();

    return switch (value) {
      'true' => true,
      'false' => false,
      _ => defaultValue,
    };
  }
}
