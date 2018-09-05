import 'package:flutter/material.dart';
import 'package:flutter_app/ClickAddPage.dart';
import 'package:flutter_app/RandomWord.dart';
import 'package:flutter_app/event/EventBus.dart';

class Entry {
  Entry(this.title, {this.route, this.children = const <Entry>[]});

  final String title;
  final Route route;
  final List<Entry> children;

  @override
  String toString() {
    return 'Entry{title: $title, route: $route, children: $children}';
  }
}

class MainPage extends StatelessWidget {
  final data = <Entry>[
    Entry("demos", children: [
      Entry("click demo",
          route: MaterialPageRoute(
              builder: (ctx) => ClickAddPage(title: "click demo"))),
      Entry("word demo",
          route: MaterialPageRoute(builder: (ctx) => RandomWords()))
    ]),
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
            print(root.route);
            //对应功能
            Navigator.of(ctx).push(root.route);
          });
    }

    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map((child) => _buildTiles(child, ctx)).toList(),
      initiallyExpanded: true,
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
