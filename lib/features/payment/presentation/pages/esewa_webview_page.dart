import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsewaWebviewPage extends StatefulWidget {
  final String formUrl;
  final Map<String, dynamic> fields;

  /// Backend callback URLs (must match your backend)
  final String successUrlPrefix;
  final String failureUrlPrefix;

  const EsewaWebviewPage({
    super.key,
    required this.formUrl,
    required this.fields,
    required this.successUrlPrefix,
    required this.failureUrlPrefix,
  });

  @override
  State<EsewaWebviewPage> createState() => _EsewaWebviewPageState();
}

class _EsewaWebviewPageState extends State<EsewaWebviewPage> {
  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => loading = false);
          },
          onNavigationRequest: (req) {
  final url = req.url;

  // ✅ 1) Close when backend callback is hit
  if (url.startsWith(widget.successUrlPrefix)) {
    Navigator.pop(context, true);
    return NavigationDecision.prevent;
  }
  if (url.startsWith(widget.failureUrlPrefix)) {
    Navigator.pop(context, false);
    return NavigationDecision.prevent;
  }

  // ✅ 2) ALSO close if backend redirects to web dashboard
  // (because your backend redirects to WEB_BASE_URL/dashboard)
  if (url.contains("/dashboard") && url.contains("success=")) {
    Navigator.pop(context, true);
    return NavigationDecision.prevent;
  }
  if (url.contains("/dashboard") && (url.contains("error=") || url.contains("fail"))) {
    Navigator.pop(context, false);
    return NavigationDecision.prevent;
  }

  return NavigationDecision.navigate;
},
        ),
      );

    _postToEsewa();
  }

  void _postToEsewa() {
    final inputs = widget.fields.entries.map((e) {
      final k = e.key;
      final v = (e.value ?? "").toString();

      // ✅ FIX: correct html escaping in Dart
      final safeV = const HtmlEscape().convert(v);

      return "<input type='hidden' name='$k' value='$safeV' />";
    }).join("\n");

    final html = """
<!DOCTYPE html>
<html>
  <body onload="document.forms[0].submit()">
    <form method="POST" action="${widget.formUrl}">
      $inputs
    </form>
  </body>
</html>
""";

    controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with eSewa")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}