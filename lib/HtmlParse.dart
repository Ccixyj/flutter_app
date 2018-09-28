import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class HtmlParse extends StatelessWidget {
  final url = "https://www.yanshuo.me/r/hottest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Html parse demo"),
            Text(
              "parse for $url",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 11.0,
                  fontFamily: 'monospace'),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: http.get(url).then((r) => htmlParser.parse(r.body)),
          builder: (c, AsyncSnapshot<dom.Document> data) {
            if (data == null || data.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return YanShuoWidget(data.data);
            }
          }),
    );
  }
}

class YanShuoWidget extends StatefulWidget {
  final dom.Document doc;

  YanShuoWidget(this.doc);

  @override
  State createState() {
    return YanShuoState();
  }
}

class YanShuoState extends State<YanShuoWidget> {
  dom.Document get _doc => widget.doc;

  List<Article> articles = [];

  @override
  void initState() {
    super.initState();

    var nodes = _doc.querySelectorAll(".stream-list section[id^=post-item-]");

    articles = nodes.map((n) {
      var art = Article(n.querySelector(".title").text.trim());
      art.content = n.querySelector(".wordbreak")?.text?.trim();
      var handler = n.querySelector(".post-handle")?.children ;
      if(handler.isNotEmpty){
        art.time = (handler.first?.querySelectorAll("a")?.last?.text?.trim() ?? "" )+ (handler?.first?.querySelector(".askDate")?.text?.trim() ?? "");
        art.from = handler?.last?.querySelectorAll("a")?.last?.text?.trim();
      }

      return art;
    }).toList();

    print(articles);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return Text("$i : ${articles[i].toString()}");
      },
      itemCount: articles.length,
    );
  }
}

class Article {
  final String title;
  String content;
  String time;
  String from;
  String image;

  Article(this.title, {this.content, this.time, this.from, this.image});

  @override
  String toString() {
    return 'Article{title: $title, content: $content, time: $time, from: $from, image: $image}';
  }


}
