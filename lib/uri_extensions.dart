import 'dart:html' as html;

extension UriExtensions on Uri {
  String? getQueryParameter(String key) => queryParameters[key];

  static Uri get currentUrl => Uri.parse(html.window.location.href);
}
