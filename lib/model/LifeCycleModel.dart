import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class LifeCycleModel extends Model {
  var _listStates = <AppLifecycleState>[];

  static LifeCycleModel of(BuildContext context) =>
      ScopedModel.of<LifeCycleModel>(context);

  List<AppLifecycleState> get eventStates => _listStates.toList();

  void add(AppLifecycleState s) {
    print("add event $s");

    _listStates.add(s);
    notifyListeners();
  }
}
