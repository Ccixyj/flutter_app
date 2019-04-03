import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;

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
      body: FutureBuilder<List<Article>>(
          future:
              http.get(url).then((r) => htmlParser.parse(r.body)).then((doc) {
            var nodes =
                doc.querySelectorAll(".stream-list section[id^=post-item-]");
            return nodes.map((n) {
              var art = Article(n.querySelector(".title").text.trim());
              art.content = n.querySelector(".wordbreak")?.text?.trim();
              var handler = n.querySelector(".post-handle")?.children;
              if (handler.isNotEmpty) {
                var img = n.querySelector("img");
                art.image = "http:" +
                    (img.attributes["data-original"] ?? img.attributes["src"]);

                if (art.image.startsWith("//"))
                  art.time = (handler.first
                              ?.querySelectorAll("a")
                              ?.last
                              ?.text
                              ?.trim() ??
                          "") +
                      (handler?.first
                              ?.querySelector(".askDate")
                              ?.text
                              ?.trim() ??
                          "");
                art.time = (handler.first
                            ?.querySelectorAll("a")
                            ?.last
                            ?.text
                            ?.trim() ??
                        "") +
                    (handler?.first?.querySelector(".askDate")?.text?.trim() ??
                        "");
                art.from =
                    handler?.last?.querySelectorAll("a")?.last?.text?.trim();
              }

              return art;
            }).toList();
          }),
          builder: (c, AsyncSnapshot<List<Article>> data) {
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
  final List<Article> articles;

  YanShuoWidget(this.articles);

  @override
  State createState() {
    return YanShuoState();
  }
}

class YanShuoState extends State<YanShuoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          var art = widget.articles[index];
          return renderRow(art);
        },
        itemCount: widget.articles.length);
  }

  Widget renderRow(Article art) {
    print(art);
    List<Widget> chs = [];
    if (art.image != null && art.image.length > 0) {
      chs.add(Container(
        margin: EdgeInsets.all(10.0),
        width: 80.0,
        height: 78.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          image: DecorationImage(
              image: NetworkImage(art.image),
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter),
        ),
      ));
    }
    List<Widget> body = [];
    body.add(Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        art.title ?? "",
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
      ),
    ));
    if (art.content != null && art.content.isNotEmpty) {
      body.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child:
            Text(art.content ?? "", style: const TextStyle(color: Colors.grey)),
      ));
    }
    body.add(Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(art.from ?? ""),
    ));
    body.add(Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(art.time ?? ""),
    ));

    final txtColum = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body,
      ),
    );
    chs.add(txtColum);
    return Row(
      children: chs,
    );
  }
}
