import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../uniapp/global.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    uniapp.initChannel();
    return CupertinoApp(
      title: 'FlutterApp',
      navigatorObservers: [GLObserver()],
      initialRoute: '/',
      routes: {
        '/': (context) {
          uniapp.setContext(context);
          return Scaffold(
              body: Center(
                  child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("hello, Flutter."),
              Text("hello, Flutter."),
              Text("hello, Flutter."),
              Text(MediaQuery.of(context).padding.top.toString()),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/second");
                },
                child: const Text('Go Second'),
              ),
              ElevatedButton(
                onPressed: () {
                  uniapp.$emit("test", {"a": 1});
                },
                child: const Text('打开uniMP小程序'),
              )
            ],
          )));
        },
        '/second': (context) => Scaffold(
                body: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("hello, Second."),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/three");
                  },
                  child: const Text('Go Three'),
                )
              ],
            ))),
        '/three': (context) =>
            Scaffold(body: Center(child: Text("hello, Three.")))
      },
    );
  }
}
