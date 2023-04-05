import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniappMethodChannel {
  final _CHANNEL_NAME = "com.itfenbao.uniapp";
  late MethodChannel _channel;
  BuildContext? _context;
  final Map<String, Function(Map<String, dynamic> map)> _methodHandlers =
      new Map();
  bool isInit = false;
  double _sh = 0;

  double get statusBarHeight {
    // var su = ScreenUtil();
    // if (su != null && su.statusBarHeight > 0) {
    //   return su.statusBarHeight;
    // } else {
    //   if (_sh > 0) return _sh;
    //   return 30;
    // }
    return 30;
  }

  void initChannel() {
    if (isInit) return;
    isInit = true;
    _channel = MethodChannel(_CHANNEL_NAME);
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "canPop") {
        sendCanPop();
      } else {
        if (_methodHandlers.containsKey(call.method)) {
          if (call.arguments != null) {
            Function.apply(_methodHandlers[call.method] as Function,
                [Map<String, dynamic>.from(call.arguments)]);
          } else {
            Function.apply(_methodHandlers[call.method] as Function, []);
          }
        } else {
          throw Exception('not implemented ${call.method}');
        }
      }
    });
  }

  void setContext(BuildContext context) {
    _context ??= context;
    _sh = MediaQuery.of(context).padding.top;
  }

  void sendCanPop() {
      fireEvent("canPop", canPop());
  }

  bool canPop() {
    if(_context == null) return false;
    try {
      return Navigator.canPop(_context!);
    } catch(e) {
      return false;
    }
  }

  void pop() {
    if (canPop()) {
      Navigator.maybePop(_context!);
    } else {
      fireEvent("pop");
    }
  }

  ///
  /// 监听uniapp事件
  ///
  void $on(String method, Function(Map<String, dynamic> map) handler) {
    _methodHandlers[method] = handler;
  }

  ///
  /// 取消uniapp事件监听
  ///
  void $off(String method) {
    _methodHandlers.remove(method);
  }

  ///
  /// 给uniapp发送事件
  ///
  void $emit(String eventName, [dynamic arguments]) {
    fireEvent(eventName, arguments);
  }

  ///
  /// 给uniapp发送事件（同步）
  ///
  Future $emitSync(String eventName, [dynamic arguments]) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = 25;

    /// 生成的字符串固定长度
    String left = "";
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    var params = new Map<String, dynamic>.from(arguments);
    params["callbackId"] = eventName + "&" + left;
    return fireEvent(eventName, params);
  }

  ///
  /// 调用uniapp回调
  ///
  void callback(String callbackId, [dynamic arguments]) {
    var params = new Map<String, dynamic>.from(arguments);
    params["callbackId"] = callbackId;
    fireEvent('_uni_callback', params);
  }

  ///
  /// 调用uniapp回调（持久回调）
  ///
  void callbackKeepAlive(String callbackId, [dynamic arguments]) {
    var params = new Map<String, dynamic>.from(arguments);
    params["callbackId"] = callbackId;
    params["keepAlive"] = true;
    fireEvent('_uni_callback', params);
  }

  Future fireEvent(String eventName, [dynamic arguments]) {
    if (isInit) {
      return _channel.invokeMethod(eventName, arguments);
    }
    return Future.value(null);
  }
}
