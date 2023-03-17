import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:webf/devtools.dart';
import 'package:webf/webf.dart';
import 'package:webf_websocket/webf_websocket.dart';

void initWebF() {
  WebFWebSocket.initialize();
}

class WebFApp extends StatelessWidget {
  const WebFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: Center(child: Text("hello, Flutter."))),
      onGenerateRoute: (RouteSettings settings) {
        String name = settings.name ?? "";
        return buildPage(name);
      },
    );
  }

  PageRoute buildPage(String name) {
    return CupertinoPageRoute(builder: (BuildContext context) {
      WebFNavigationDelegate navigationDelegate = WebFNavigationDelegate();
      navigationDelegate
          .setDecisionHandler((WebFNavigationAction action) async {
        if (action.source == null) return WebFNavigationActionPolicy.cancel;
        Uri uri = Uri.parse(action.source!);
        String scheme = "${uri.scheme}:///";
        String name = "";
        if (uri.scheme == 'http' ||
            uri.scheme == 'https' ||
            uri.scheme == 'assets') {
          name = action.target;
        } else {
          String basePath = action.source!.replaceFirst(scheme, "");
          if (['./', '../', '/']
              .any((element) => action.target.startsWith(element))) {
            basePath = basePath.substring(0, basePath.lastIndexOf("/"));
            name = p.normalize(basePath + action.target);
          } else {
            basePath =
                basePath.substring(0, basePath.lastIndexOf("www/static"));
            name = p.normalize(basePath + "www/static/" + action.target);
          }
        }
        Navigator.push(context, buildPage("$scheme$name"));
        return WebFNavigationActionPolicy.allow;
      });
      MediaQueryData queryData = MediaQuery.of(context);
      Size viewportSize = queryData.size;
      return Scaffold(
          body: Center(
        child: Column(
          children: [
            WebF(
              devToolsService: ChromeDevToolsService(),
              // Enable Chrome DevTools Services
              navigationDelegate: navigationDelegate,
              viewportWidth: viewportSize.width - queryData.padding.horizontal,
              viewportHeight: viewportSize.height - queryData.padding.vertical,
              bundle: WebFBundle.fromUrl(name), // The page entry point
            ),
          ],
        ),
      ));
    });
  }
}
