import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libflutter/page/webf_page.dart';

// void main() => runApp(const MyApp());

void main() {
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
