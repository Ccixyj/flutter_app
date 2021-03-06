import 'package:flutter/material.dart';
import 'package:flutter_app/ClickAddPage.dart';
import 'package:flutter_app/HtmlParse.dart';
import 'package:flutter_app/InfoPage.dart';
import 'package:flutter_app/RandomWord.dart';
import 'package:flutter_app/UnlimitedImagePage.dart';
import 'package:flutter_app/event/EventBus.dart';
import 'package:flutter_app/model/LifeCycleModel.dart';
import 'package:flutter_app/model/LifeCycleViewModel.dart';
import 'android/dev/View.dart';
import 'package:scoped_model/scoped_model.dart';

class Entry {
  const Entry(this.title, {this.builder, this.children = const <Entry>[]});

  final String title;
  final WidgetBuilder builder;
  final List<Entry> children;

  @override
  String toString() {
    return 'Entry{title: $title, route: $builder, children: $children}';
  }
}

class MainPage extends StatelessWidget {
  static final eventModel = new LifeCycleModel();

  final data = <Entry>[
    Entry("demos", children: [
      Entry("click demo", builder: (ctx) => ClickAddPage(title: "click demo")),
      Entry("word demo", builder: (ctx) => RandomWords()),
      Entry("html parse", builder: (ctx) => HtmlParse()),
      Entry("image more and more", builder: (ctx) => UnlimitedImagePage())
    ]),
    Entry("Flutter for Android Developers", children: [
      Entry("  View", children: [
        Entry("    introduce", builder: (ctx) => InfoPage.info('''
This document is meant for Android developers looking to apply their existing Android knowledge to build mobile apps with Flutter. If you understand the fundamentals of the Android framework then you can use this document as a jump start to Flutter development.

Your Android knowledge and skill set are highly valuable when building with Flutter, because Flutter relies on the mobile operating system for numerous capabilities and configurations. Flutter is a new way to build UIs for mobile, but it has a plugin system to communicate with Android (and iOS) for non-UI tasks. If you’re an expert with Android, you don’t have to relearn everything to use Flutter.

This document can be used as a cookbook by jumping around and finding questions that are most relevant to your needs.
        
         ''')),
        Entry("    How do I update Widgets?", builder: (ctx) => ViewPage(1)),
        Entry("    How do I add or remove a component from my layout?",
            builder: (ctx) => ViewPage(2)),
        Entry("    How do I animate a widget?", builder: (ctx) => ViewPage(3)),
        Entry("    How do I use a Canvas to draw/paint?",
            builder: (ctx) => ViewPage(4)),
        Entry("    How do I build custom widgets?",
            builder: (ctx) => ViewPage(5)),
        Entry("    How do I use inheritWidgets?",
            builder: (ctx) => ViewPage(51)),
      ]),
      Entry("  Intent", children: [
        Entry(
            "    How do I handle incoming intents from external applications in Flutter? ",
            builder: (ctx) => ViewPage(6)),
        Entry("     What is the equivalent of startActivityForResult()?",
            builder: (ctx) => ViewPage(7))
      ]),
      Entry("  Async UI", children: [
        Entry("    What is the equivalent of runOnUiThread() in Flutter?",
            builder: (ctx) => ViewPage(8)),
        Entry("     How do you move work to a background thread?",
            builder: (ctx) => ViewPage(9))
      ]),
      Entry("  Project structure & resources", children: [
        Entry("    Where do I store my resolution-dependent image files?",
            builder: (ctx) => ViewPage(10)),
      ]),
      Entry("  Activities and fragments", children: [
        Entry(
            "    How do I listen to Android activity lifecycle events(ScopedModel)?",
            builder: (ctx) => ScopedModel<LifeCycleModel>(
                  model: eventModel,
                  child: ViewPage(11),
                )),
        Entry("    How do I use state mvvm (RxDart)?",
            builder: (ctx) => ViewPage(12))
      ])
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select an item show"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: "refresh theme",
              onPressed: () {
                eventBus.fire(ThemeEvent());
              }),
          IconButton(
              icon: const Icon(Icons.info),
              tooltip: "show theme info",
              onPressed: () {
                print(data);
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}


class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root, BuildContext ctx) {
    if (root.children.isEmpty) {
      return ListTile(
          title: Text(root.title),
          onTap: () {
            print(root);
            //对应功能
            var f =
                Navigator.push(ctx, MaterialPageRoute(builder: root.builder));
            f.asStream().listen((e) {
              print("pop back value is :${e.toString()}");
            });
          });
    }

    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map((child) => _buildTiles(child, ctx)).toList(),
      initiallyExpanded: false,
      onExpansionChanged: (b) {
        print("expand $b");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry, context);
  }
}
