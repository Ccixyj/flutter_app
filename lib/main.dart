import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/MainPage.dart';
import 'package:flutter_app/event/EventBus.dart';

void main() {
  const chan = const MethodChannel('app.channel.plugin/toast');
  eventBus.on<ToastEvent>().listen((e) {
    print("ToastEvent $e");
    chan.invokeMethod("androidToast",e.content);
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State createState() {
    return AppState();
  }
}

class AppState extends State<MyApp> {
  final r = Random(DateTime.now().millisecondsSinceEpoch);

  MaterialColor themeColor;

  MaterialColor getRandomTheme() {
    return Colors.primaries[r.nextInt(Colors.primaries.length)];
  }

  StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    themeColor = getRandomTheme();
    sub = eventBus.on<ThemeEvent>().listen((e) {
      setState(() {
        themeColor = getRandomTheme();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: themeColor,
      ),
      home: MainPage(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }
}
