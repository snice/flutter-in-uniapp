import 'package:flutter/cupertino.dart';

import './channel.dart';

UniappMethodChannel uniapp = UniappMethodChannel();

class GLObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    uniapp.sendCanPop();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print("pop:${route.settings.toString()}");
    super.didPop(route, previousRoute);
    uniapp.sendCanPop();
  }
}
