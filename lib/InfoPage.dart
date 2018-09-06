import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(_info),
          ),
        ),
      );

  String _info;

  InfoPage.info(String info) {
    this._info = info;
  }
}
