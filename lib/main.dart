import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'uri_extensions.dart';
import 'string_extensions.dart';

bool shouldEnableSemantics({bool enableSemanticsPerFlavor = false}) =>
    'enableSemantics'.toBoolFromQuery(defaultValue: enableSemanticsPerFlavor);

// NOTE: a button to enable from flutter doens't help
// bc the button won't be tappable by automation unless the semantics are there

void main() {
  runApp(const MyApp());

  // Enable semantics for web if enableSemantics=true in URL
  if (kIsWeb &&
      UriExtensions.currentUrl
              .getQueryParameter('enableSemantics')
              ?.toLowerCase() ==
          'true') {
    SemanticsBinding.instance.ensureSemantics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _semanticsEnabled = false;

  @override
  void initState() {
    super.initState();
    _semanticsEnabled =
        UriExtensions.currentUrl
            .getQueryParameter('enableSemantics')
            ?.toLowerCase() ==
        'true';
  }

  void _toggleSemantics(bool enable) {
    setState(() => _semanticsEnabled = enable);

    if (enable) {
      SemanticsBinding.instance.ensureSemantics();
      html.window.history.pushState(
        null,
        '',
        UriExtensions.currentUrl
            .replace(
              queryParameters: {
                ...UriExtensions.currentUrl.queryParameters,
                'enableSemantics': 'true',
              },
            )
            .toString(),
      );

    } else {
      final uri = UriExtensions.currentUrl;
      final params = Map<String, String>.from(uri.queryParameters);
      params.remove('enableSemantics');
      html.window.history.pushState(
        null,
        '',
        uri.replace(queryParameters: params).toString(),
      );
      html.window.location.reload();
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QueryString Semantics Demo',
      routes: {
        '/': (context) => QueryStringPage(
          semanticsEnabled: _semanticsEnabled,
          onToggleSemantics: _toggleSemantics,
        ),
        '/page1': (context) => Page1(
          semanticsEnabled: _semanticsEnabled,
          onToggleSemantics: _toggleSemantics,
        ),
        '/page2': (context) => Page2(
          semanticsEnabled: _semanticsEnabled,
          onToggleSemantics: _toggleSemantics,
        ),
      },
    );
}

class QueryStringPage extends StatefulWidget {
  final bool semanticsEnabled;
  final Function(bool) onToggleSemantics;

  const QueryStringPage({
    super.key,
    required this.semanticsEnabled,
    required this.onToggleSemantics,
  });

  @override
  State<QueryStringPage> createState() => _QueryStringPageState();
}

class _QueryStringPageState extends State<QueryStringPage> {
  String _queryString = '';
  bool _enableSemantics = false;

  @override
  void initState() {
    super.initState();
    _parseQueryString();
  }

  void _parseQueryString() {
    final uri = UriExtensions.currentUrl;
    _queryString = uri.query;
    _enableSemantics = 'enableSemantics'.toBoolFromQuery();
    setState(() {});
  }

  void _setEnableSemantics(bool value) {
    final uri = UriExtensions.currentUrl;
    final newUri = uri.replace(
      queryParameters: {'enableSemantics': value.toString()},
    );
    html.window.history.pushState(null, '', newUri.toString());

    // Actually enable/disable semantics
    // Note: There's no direct way to disable semantics once enabled

    if (value) {
      SemanticsBinding.instance.ensureSemantics();
    }
    _parseQueryString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QueryString Semantics Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Query String:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _queryString.isEmpty ? '(empty)' : _queryString,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _queryString.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Enable Semantics:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _enableSemantics.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _enableSemantics ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _setEnableSemantics(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Enable Semantics'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _setEnableSemantics(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Disable Semantics'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _parseQueryString,
                  child: const Text('Refresh'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Reload page to disable semantics
                    html.window.location.reload();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Disable Semantics (Reload)'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Note: To disable semantics, reload the page',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page1'),
              child: const Text('Go to Page 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page2'),
              child: const Text('Go to Page 2'),
            ),
          ],
        ),
      ),
    );
}

class Page1 extends StatelessWidget {
  final bool semanticsEnabled;
  final Function(bool) onToggleSemantics;

  const Page1({
    super.key,
    required this.semanticsEnabled,
    required this.onToggleSemantics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page 1 App Bar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page 1 Body',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Semantics: ${semanticsEnabled ? "Enabled" : "Disabled"}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: semanticsEnabled ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Go to Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page2'),
              child: const Text('Go to Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final bool semanticsEnabled;
  final Function(bool) onToggleSemantics;

  const Page2({
    super.key,
    required this.semanticsEnabled,
    required this.onToggleSemantics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page 2',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Semantics: ${semanticsEnabled ? "Enabled" : "Disabled"}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: semanticsEnabled ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Go to Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page1'),
              child: const Text('Go to Page 1'),
            ),
          ],
        ),
      ),
    );
  }
}
