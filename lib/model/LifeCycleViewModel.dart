import 'dart:async';
import 'package:english_words/english_words.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class LifeCycleViewModel {
  List<WordPair> _ds = [];
  final txtController =  TextEditingController();
  RxCommand<String, List<WordPair>> wordCommand;
  RxCommand<void, int> lengthCommand;

  RxCommand<bool, bool> switchCommand =
      RxCommand.createSync3<bool, bool>((b) => b);

  RxCommand<void, String> textChangedCommand;

  LifeCycleViewModel() {
    wordCommand = RxCommand.createAsync3(_filter, canExecute: switchCommand);
    textChangedCommand = RxCommand.createSync2(() => txtController.text);
    txtController.addListener(textChangedCommand);
    generate(1000);
    // handler for results
    textChangedCommand
        .debounce(new Duration(
            milliseconds:
                300)) // make sure we start processing only if the user make a short pause typing
        .listen((filterText) {
      print("filter text $filterText");
      wordCommand.execute(filterText);
    });
  }

  void generate(int i) {
    _ds.clear();
    _ds.addAll(generateWordPairs().take(i).toList());
    txtController.clear();
    wordCommand.execute(textChangedCommand.lastResult ?? "");
  }

  void dispose() {
    txtController.removeListener(textChangedCommand);
    txtController.dispose();
    switchCommand.dispose();
    wordCommand.dispose();
  }

  remove(int i) {
    print("remove $i");
//    _ds.removeAt(i);
  }

  Future<List<WordPair>> _filter(String p) {
    print("filter  p = $p for ${_ds.take(12)}");
    if (p == null || p.isEmpty) {
      return Future.value(_ds);
    }
    return Future.delayed(Duration(milliseconds: 1600), () {
      var t = _ds
          .where((s) => s.toLowerCase().toString().contains(p.toLowerCase()))
          .toList();
      print("filter result len() =${t.length} , ${t.take(12)}");
      return t;
    });
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
