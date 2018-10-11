import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/MainPage.dart';
import 'package:flutter_app/event/EventBus.dart';


class ImmutablePoint {
  final num  x, y;

  const ImmutablePoint(this.x, this.y);
}



void main() {
  var a = const ImmutablePoint(1, 1);
  var b = const ImmutablePoint(1, 1);
  assert(identical(a, b)); // They are the same instance!

  // Lots of const keywords here.
  const pointAndLine = const {
    'point': const [const ImmutablePoint(0, 0)],
    'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
  };

  final pointAndLine2 = const {
    'point': const [const ImmutablePoint(0, 0)],
    'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
  };

  const pointAndLine3 =  {
    'point':  [ ImmutablePoint(0, 0)],
    'line':  [ ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
  };

  final pointAndLine4 =  {
    'point':  [ ImmutablePoint(0, 0)],
    'line':  [ ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
  };

  print("id : ${identical(pointAndLine, pointAndLine2)}");
  print("id : ${identical(pointAndLine, pointAndLine3)}");
  print("id : ${identical(pointAndLine2, pointAndLine3)}");
  print("id : ${identical(pointAndLine2, pointAndLine4)}");


  final c =  ImmutablePoint(1, 1);
  print(identical(a, c));

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
