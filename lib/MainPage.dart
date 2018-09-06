import 'package:flutter/material.dart';
import 'package:flutter_app/ClickAddPage.dart';
import 'package:flutter_app/InfoPage.dart';
import 'package:flutter_app/RandomWord.dart';
import 'package:flutter_app/event/EventBus.dart';
import 'android/dev/View.dart';

class Entry {
  Entry(this.title, {this.builder, this.children = const <Entry>[]});

  final String title;
  final WidgetBuilder builder;
  final List<Entry> children;

  @override
  String toString() {
    return 'Entry{title: $title, route: $builder, children: $children}';
  }
}

class MainPage extends StatelessWidget {
  final data = <Entry>[
    Entry("demos", children: [
      Entry("click demo", builder: (ctx) => ClickAddPage(title: "click demo")),
      Entry("word demo", builder: (ctx) => RandomWords())
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
      ]),
      Entry("  Intent", children: [
        Entry(
            "     How do I handle incoming intents from external applications in Flutter? ",
            builder: (ctx) => ViewPage(6))
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
              icon: new Icon(Icons.refresh),
              tooltip: "refresh theme",
              onPressed: () {
                eventBus.fire(ThemeEvent());
              }),
          IconButton(
              icon: new Icon(Icons.info),
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
            Navigator.push(ctx, MaterialPageRoute(builder: root.builder));
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
