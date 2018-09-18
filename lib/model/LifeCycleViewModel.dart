import 'dart:async';
import 'package:english_words/english_words.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';

class LifeCycleViewModel {
  List<WordPair> _ds = [];

  RxCommand<String, List<WordPair>> appStateCommand;
  RxCommand<void, int> lengthCommand;

  RxCommand<bool, bool> switchCommand =
      RxCommand.createSync3<bool, bool>((b) => b);

  RxCommand<String, String> textChangedCommand;

  LifeCycleViewModel() {
    appStateCommand =
        RxCommand.createAsync3(_generate, canExecute: switchCommand);
    appStateCommand.listen((d){
      _ds.addAll(d);
      print("listen ${_ds.length}");
    });
    appStateCommand.execute();
    lengthCommand =RxCommand.createSync(()=>_ds.length);

    textChangedCommand = RxCommand.createSync3((s) {
      print("get value change $s");
      return s;
    });

    // handler for results
    textChangedCommand
        .debounce(new Duration(
            milliseconds:
                500)) // make sure we start processing only if the user make a short pause typing
        .listen((filterText) {
      print("filter text $filterText");
      _ds.clear();
      appStateCommand.execute(filterText);
    });
  }

  Future<List<WordPair>> _generate(String s) {
    print("_generate $s");
    if ((s == null || s.isEmpty) && _ds.isEmpty) {
      return Future.delayed(Duration(seconds: 1), () {
        return generateWordPairs().take(1000).toList();
      });
    }

    return Future.delayed(Duration(seconds: 2), () {
      return   _ds.where((w) => w.toLowerCase().toString().contains(s)).toList();
    });
  }

  void dispose() {
    switchCommand.dispose();
    appStateCommand.dispose();
  }

  remove(int i) {
    print("remove $i");
//    _ds.removeAt(i);
  }
}

class LifeCycleProvider extends InheritedWidget {
  final LifeCycleViewModel viewModel;

  LifeCycleProvider(this.viewModel, {Key key, @required Widget child})
      : assert(viewModel != null),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(LifeCycleProvider oldWidget) =>
      this.viewModel != oldWidget.viewModel;

  static LifeCycleViewModel of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LifeCycleProvider)
              as LifeCycleProvider)
          .viewModel;
}
