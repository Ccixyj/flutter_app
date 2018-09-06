import 'dart:async';
import 'package:async/async.dart';
import 'package:english_words/english_words.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/event/EventBus.dart';

class ViewPage extends StatefulWidget {
  ViewPage(this.caseType);

  int caseType = 0;

  @override
  State createState() {
    switch (caseType) {
      case 1:
        return _UpdateViewPageState();

      case 2:
        return _ToggleViewPageState();

      case 3:
        return _AnimateViewPageState();

      case 4:
        return _SignatureState();

      case 5:
        return _CustomState();
      case 6:
        return _InterActAppPageState();
    }
  }
}

class _UpdateViewPageState extends State<ViewPage> {
  // Default placeholder text
  String textToShow = "I Like Flutter";

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How to Update Text"),
      ),
      body: Center(child: Text(textToShow)),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}

class _ToggleViewPageState extends State<ViewPage> {
  // Default placeholder text
  var toggle = true;
  final sKey = GlobalKey<ScaffoldState>();

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  Widget _getWidget(BuildContext ctx) {
    if (toggle) {
      return Text('Toggle One');
    } else {
      return MaterialButton(
          onPressed: () {
            print(ctx.hashCode);
            print(ctx.widget);
            print(sKey.currentState);
            print(sKey.currentWidget);
            print(sKey.currentContext);

            sKey.currentState
                .showSnackBar(SnackBar(content: Text("click button ")));
          },
          child: Text('Toggle Two'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      appBar: AppBar(
        title: Text("How to Toggle Text"),
      ),
      body: Builder(builder: (ctx) {
        return Center(child: _getWidget(ctx));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Toggle Text',
        child: Icon(Icons.swap_calls),
      ),
    );
  }
}

class _AnimateViewPageState extends State<ViewPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animation;
  double op = 1.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animate view"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FadeTransition(
            opacity: animation,
            child: FlutterLogo(
              size: 100.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                op = op == 0.0 ? 1.0 : 0.0;
              });
            },
            child: AnimatedOpacity(
              opacity: op,
              duration: Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.only(
                    right: 20.0, bottom: 15.0, left: 20.0),
                child: Text(
                    "和React Native一样，Flutter也提供响应式的视图，Flutter采用不同的方法避免由JavaScript桥接器引起的性能问题，即用名为Dart的程序语言来编译。Dart是用预编译的方式编译多个平台的原生代码，这允许Flutter直接与平台通信，而不需要通过执行上下文切换的JavaScript桥接器。编译为原生代码也可以加快应用程序的启动时间。实际上，Flutter是唯一提供响应式视图而不需要JavaScript桥接器的移动SDK，这就足以让Fluttter变得有趣而值得一试，但Flutter还有一些革命性的东西，即它是如何实现UI组件的？"),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.reset();
          Future.delayed(Duration(milliseconds: 800), () {
            controller.forward();
          });
        },
        tooltip: 'Update Text',
        child: Icon(Icons.brush),
      ),
    );
  }
}

class _SignatureState extends State<ViewPage> {
  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
          print("$referenceBox : $localPosition");
          _points.add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child:
          CustomPaint(painter: SignaturePainter(_points), size: Size.infinite),
    ));
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;
    print("Start 0 ${points.length}");

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  ///总是重绘
  bool shouldRepaint(SignaturePainter other) => true;
}

class _CustomState extends State<ViewPage> {
  Widget _buildBtn(BuildContext ctx, StateSetter s) {
    var label = WordPair.random().asCamelCase;

    return RaisedButton(
        onPressed: () {
          s(() => label = WordPair.random().asCamelCase);
        },
        child: Text(label));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StatefulBuilder(builder: _buildBtn),
      ),
    );
  }
}

class _InterActAppPageState extends State<ViewPage> {
  static const chann = const MethodChannel('app.channel.plugin/share');
  String dataShared = "No data";
  CancelableOperation f;

  @override
  void initState() {
    super.initState();
    uuid();
    f = testToast();
    chann.setMethodCallHandler((call) {
      switch (call.method) {
        case "getWord":
          return Future.value(
              "from flutter : ${WordPair.random().asCamelCase}");
          break;

        case "getWordWithParams":
          return Future.value(
              "from flutter : params ${call.arguments}  ${WordPair.random().asCamelCase}");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(dataShared)));
  }


  @override
  void dispose() {
    print("cancel f");
    f.cancel();
    super.dispose();
  }

  uuid() async {
    var sharedData = await chann.invokeMethod("getUUID");
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData;
      });
    }
  }

  CancelableOperation testToast() {
    return CancelableOperation.fromFuture(Future.delayed(Duration(seconds: 2), () {
    }).then((e) {
      print("mounted $mounted");
      eventBus.fire(ToastEvent("testToast"));
      setState(() {
        dataShared = "send toast ok!~";
      });
    }));
  }
}
