import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:webf/devtools.dart';
import 'package:webf/webf.dart';
import 'package:webf_websocket/webf_websocket.dart';

import '../uniapp/global.dart';

void initWebF() {
  WebFWebSocket.initialize();
}

class WebFApp extends StatelessWidget {
  const WebFApp({super.key});

  @override
  Widget build(BuildContext context) {
    uniapp.initChannel();
    return CupertinoApp(
      title: 'Flutter Demo',
      home: const Scaffold(body: Center(child: Text("hello, Flutter."))),
      navigatorObservers: [GLObserver()],
      onGenerateRoute: (RouteSettings settings) {
        return buildPage(settings);
      },
    );
  }

  PageRoute buildPage(RouteSettings settings) {
    String url = settings.name ?? "";
    return CupertinoPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          uniapp.setContext(context);
          MediaQueryData queryData = MediaQuery.of(context);
          Size viewportSize = queryData.size;
          return Scaffold(
              body: Center(
            child: Column(
              children: [
                WebF(
                  // Enable Chrome DevTools Services
                  devToolsService: ChromeDevToolsService(),
                  navigationDelegate: createNavigationDelegate(context),
                  viewportWidth: viewportSize.width - queryData.padding.horizontal,
                  viewportHeight: viewportSize.height, //- queryData.padding.vertical,
                  bundle: WebFBundle.fromUrl(url), // The page entry point
                ),
              ],
            ),
          ));
        });
  }

  WebFNavigationDelegate createNavigationDelegate(BuildContext context) {
    WebFNavigationDelegate navigationDelegate = WebFNavigationDelegate();
    navigationDelegate.errorHandler = (error, task) {
      print(error);
    };
    navigationDelegate.setDecisionHandler((WebFNavigationAction action) async {
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
        if (['./', '../', '/'].any((element) => action.target.startsWith(element))) {
          basePath = basePath.substring(0, basePath.lastIndexOf("/"));
          name = p.normalize(basePath + action.target);
        } else {
          basePath = basePath.substring(0, basePath.lastIndexOf("www/static"));
          name = p.normalize(basePath + "www/static/" + action.target);
        }
      }
      String fullPath = "$scheme$name";
      print("webf push:$fullPath");
      Navigator.push(context, buildPage(RouteSettings(name: fullPath, arguments: null)));
      return WebFNavigationActionPolicy.allow;
    });
    return navigationDelegate;
  }
}
