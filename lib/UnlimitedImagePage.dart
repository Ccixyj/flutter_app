import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UnlimitedImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UnlimitedImagePage"),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) => Divider(
                color: Theme.of(context).primaryColor,
              ),
          separatorBuilder: (BuildContext context, int index) => Divider(
                color: Theme.of(context).primaryColor,
              ),
          itemCount: null),
    );
  }
}
