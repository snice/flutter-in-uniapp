import 'package:flutter/cupertino.dart';

import './channel.dart';

UniappMethodChannel uniapp = UniappMethodChannel();

class GLObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.navigator?.canPop() == true) {
      _sendCanPop(true);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.navigator?.canPop() == false) {
      _sendCanPop(false);
    }
    super.didPop(route, previousRoute);
  }

  void _sendCanPop(bool canPop) {
    // 防止太快，导致返回多次
    Future.delayed(const Duration(microseconds: 50), () {
      uniapp.sendCanPop(canPop);
    });
  }

}
