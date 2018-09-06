import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _cache = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Start up for loop text  word pair"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.clear), onPressed: _shuffle)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _shuffle() {

    setState(() {
      _cache.shuffle();
    });
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        itemBuilder: (c, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;
          print("build $index $_cache");
          if (index >= _cache.length) {
            final gens = generateWordPairs().take(10);
            _cache.addAll(gens);
          }


          return _buildRow(_cache[index]);
        },
        padding: const EdgeInsets.all(16.0));
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text("${pair.asPascalCase} => ${pair.asPascalCase}",
          style: _biggerFont),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.greenAccent.shade200,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
