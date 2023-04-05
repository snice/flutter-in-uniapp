import 'package:flutter/cupertino.dart';

import './channel.dart';

UniappMethodChannel uniapp = UniappMethodChannel();

class GLObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _sendCanPop();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _sendCanPop();
  }

  void _sendCanPop() {
    // 防止太快，导致返回多次
    Future.delayed(const Duration(microseconds: 50), () {
      uniapp.sendCanPop();
    });
  }

}
