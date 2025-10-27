import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'uri_extensions.dart';
import 'string_extensions.dart';

bool shouldEnableSemantics({bool enableSemanticsPerFlavor = false}) =>
    'enableSemantics'.toBoolFromQuery(defaultValue: enableSemanticsPerFlavor);

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

/// Reusable semantics toggle button for app bar
class SemanticsToggleButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const SemanticsToggleButton({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onToggle,
      child: Text(
        isEnabled ? 'Acc On' : 'Acc Off',
        style: TextStyle(color: Colors.transparent),
      ),
      onHover: (hovering) {
        // Optional: Add subtle hover effect
      },
    ).withTooltip(
      isEnabled
          ? 'Accessibility (Semantics) Enabled: Screen readers can read this page. Click to disable.'
          : 'Accessibility (Semantics) Disabled: Screen readers have limited access. Click to enable.',
    );
}

/// Extension to add tooltip to any widget
extension TooltipExtension on Widget {
  Widget withTooltip(String message) {
    return Tooltip(message: message, child: this);
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
    setState(() {
      _semanticsEnabled = enable;
    });

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

      // Verify that semantics are actually working
      _verifySemanticsInDOM();
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

  void _verifySemanticsInDOM() {
    // Wait a brief moment for DOM to update, then verify via script injection
    Future.delayed(const Duration(milliseconds: 200), () {
      // Inject and execute verification script
      final script = html.ScriptElement()
        ..type = 'text/javascript'
        ..text = 'window.verifySemanticsInDOM();';
      html.document.head!.append(script);

      print(
        '🔍 Verification triggered - check browser console for detailed results',
      );

      // Remove script after execution
      Future.delayed(const Duration(milliseconds: 100), () {
        script.remove();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QueryString Semantics Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
    if (value) {
      SemanticsBinding.instance.ensureSemantics();
    } else {
      // Note: There's no direct way to disable semantics once enabled
      // The user would need to refresh the page
    }

    _parseQueryString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QueryString Semantics Demo'),
        actions: [
          SemanticsToggleButton(
            isEnabled: widget.semanticsEnabled,
            onToggle: () => widget.onToggleSemantics(!widget.semanticsEnabled),
          ),
        ],
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
        title: const Text('Page 1'),
        actions: [
          SemanticsToggleButton(
            isEnabled: semanticsEnabled,
            onToggle: () => onToggleSemantics(!semanticsEnabled),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page 1',
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
        actions: [
          SemanticsToggleButton(
            isEnabled: semanticsEnabled,
            onToggle: () => onToggleSemantics(!semanticsEnabled),
          ),
        ],
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
