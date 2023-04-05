import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './page/def_page.dart';
import './page/webf_page.dart';

void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    //实现沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

@pragma('vm:entry-point')
void webf() {
  initWebF();
  runApp(const WebFApp());
  if (Platform.isAndroid) {
    //实现沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
