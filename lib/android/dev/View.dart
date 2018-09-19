import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:english_words/english_words.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/event/EventBus.dart';
import 'package:flutter_app/model/LifeCycleModel.dart';
import 'package:flutter_app/model/LifeCycleViewModel.dart';
import 'package:http/http.dart' as http;
import 'package:rx_command/rx_command.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ViewPage extends StatefulWidget {
  ViewPage(this.caseType);

  final int caseType;

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
      case 51:
        return _MyInheritedState();

      case 6:
        return _InterActAppPageState();

      case 7:
        return _HandlerBackResult();

      case 8:
        return _AsyncUI();

      case 9:
        return _CPUBoundUI();

      case 10:
        return _AssertsUI();

      case 11:
        return _ScopedLifeCycleWatcherUI();

      case 12:
        return _RxLifeCycleWatcherUI();

      default:
        return _EmptyUI(caseType);
    }
  }
}

class _MyInheritedState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyInheritedState"),
      ),
      body: MyInheritWidget(
        "pass value",
        child: Center(
          child: Builder(
            builder: (c) => Text(MyInheritWidget.of(c).name),
          ),
        ),
      ),
    );
  }
}

class MyInheritWidget extends InheritedWidget {
  final String name;

  MyInheritWidget(this.name, {Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(MyInheritWidget oldWidget) =>
      this.name != oldWidget.name;

  static MyInheritWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MyInheritWidget);
}

class _EmptyUI extends State<ViewPage> {
  int caseType;

  _EmptyUI(this.caseType);

  @override
  Widget build(BuildContext context) => Center(
        child: Text("nothing match for case type :$caseType "),
      );
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
  StreamSubscription f;

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

  StreamSubscription testToast() {
    return Future.delayed(Duration(milliseconds: 1200), () {
      print("delay executed!!!!");
    }).asStream().listen((t) {
      print("recive val $t");
      eventBus.fire(ToastEvent("toast event"));
    });
  }
}

class _HandlerBackResult extends State<ViewPage> {
  static const chann = const MethodChannel('app.channel.plugin/share');
  String dataShared = "No data";

  @override
  void initState() {
    super.initState();
    uuid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(dataShared)));
  }

  uuid() {
    Future.value(chann.invokeMethod("getUUID")).then((t) {
      if (t != null) {
        setState(() {
          dataShared = t;
        });
      }

      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.of(context).pop({'res': "result ok!", 'data': t});
      });
    });
  }
}

class _AsyncUI extends State<ViewPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget buildBody() {
    if (widgets.isEmpty) {
      return Center(
        child: Text("loading"),
      );
    } else {
      return ListView.builder(
        itemBuilder: _buildRow,
        itemCount: widgets.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody());
  }

  void _loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
      print(widgets);
    });
  }

  Widget _buildRow(BuildContext context, int index) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Row ${widgets[index]["title"]}"));
  }
}

class _CPUBoundUI extends State<ViewPage> {
  List widgets = [];
  SendPort sendPort;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    sendPort = await receivePort.first;

    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");
    if (this.mounted) {
      setState(() {
        widgets = msg;
      });
    }
  }

  // the entry point for the isolate
  static void dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      if (replyTo == null || data == "close") {
        port.close();
      } else {
        String dataURL = data;
        http.Response response = await http.get(dataURL);
        // Lots of JSON to parse
        replyTo.send(json.decode(response.body));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    sendPort.send(["close", null]);
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}

class _AssertsUI extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
              Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      'https://raw.githubusercontent.com/flutter/website/dash/src/_includes/code/layout/stack/images/pic.jpg',
                ),
              ),
            ],
          ),
          Divider(color: Colors.white),
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image:
                'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          ),
          Divider(color: Colors.white),
          Image.asset("assets/images/dog.jpg")
        ],
      ),
    );
  }
}

class _ScopedLifeCycleWatcherUI extends State<ViewPage>
    with WidgetsBindingObserver {
  var cacheLength = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ScopedModel.of<LifeCycleModel>(context).add(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<LifeCycleModel>(
        builder: (a, b, c) {
          return ListView.builder(
            itemBuilder: (context, i) => GestureDetector(
                  child: ListTile(
                    title: Builder(
                      builder: (ctx) {
                        print("build $i: ${c.eventStates[i]}");
                        return Text("$i . ${c.eventStates[i]}");
                      },
                    ),
                  ),
                  onTap: () {
                    print("row tapped $i . ${c.eventStates[i]}");
                  },
                ),
            itemCount: cacheLength = c.eventStates.length,
          );
        },
        rebuildOnChange:
            ScopedModel.of<LifeCycleModel>(context).eventStates.length !=
                cacheLength,
      ),
    );
  }
}

class _RxLifeCycleWatcherUI extends State<ViewPage>
    with WidgetsBindingObserver {
  final m = LifeCycleViewModel();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    m.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleProvider(
      m,
      child: Scaffold(
        appBar: AppBar(title: Text("rxcommand"), actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.refresh),
              tooltip: "new Data",
              onPressed: () {
                m.generate(1000);
              }),
          Builder(
            builder: (c) => StateFullSwitch(
                  state: true,
                  onChanged: LifeCycleProvider.of(c).switchCommand,
                ),
          ),
        ]),
        body: Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new TextField(
                autocorrect: false,
                decoration: new InputDecoration(
                  hintText: "Filter cities",
                  hintStyle:
                      new TextStyle(color: new Color.fromARGB(150, 0, 0, 0)),
                ),
                style: new TextStyle(
                    fontSize: 20.0, color: new Color.fromARGB(255, 0, 0, 0)),
                controller: m.txtController ,
              ),
            ),
            Flexible(
              child: StreamBuilder(
                  stream: m.wordCommand.isExecuting,
                  builder: (BuildContext c, AsyncSnapshot<bool> asyncData) {
                    if (asyncData.hasData && asyncData.data) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var res = m.wordCommand.lastResult;
                      print(res);
                      if (res != null && res.isNotEmpty) {
                        var data = m.wordCommand.lastResult;
                        return ListView.builder(
                            itemBuilder: (context, i) => GestureDetector(
                                  child: ListTile(
                                    title: Builder(
                                      builder: (ctx) {
                                        print("build $i: ${data[i]}");
                                        return Text("$i . ${data[i]}");
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    print("row tapped $i . ${data[i]}");
                                  },
                                  onLongPress: () {
                                    m.remove(i);
                                  },
                                ),
                            itemCount: data.length);
                      } else {
                        return Center(
                          child: Text("No Data"),
                        );
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class StateFullSwitch extends StatefulWidget {
  final bool state;
  final ValueChanged<bool> onChanged;

  StateFullSwitch({this.state, this.onChanged});

  @override
  StateFullSwitchState createState() {
    return new StateFullSwitchState(state, onChanged);
  }
}

class StateFullSwitchState extends State<StateFullSwitch> {
  bool state;
  ValueChanged<bool> handler;

  StateFullSwitchState(this.state, this.handler);

  @override
  Widget build(BuildContext context) {
    return new Switch(
        value: state,
        onChanged: (b) {
          setState(() => state = b);
          handler(b);
        });
  }
}
