import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello/detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  dynamic a = 5;

  @override
  Widget build(BuildContext context) {
    //final WordPair wordPair = WordPair.random();
    a = "aa";
    print(a);

    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.red,
        secondaryHeaderColor: Colors.purple
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _smallFont = TextStyle();

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
        textAlign: TextAlign.right,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.yellow,
      ),
      subtitle: Text(
        pair.asPascalCase,
        style: _smallFont,
        textAlign: TextAlign.left,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved, tooltip: "AAAAA"),
        ],        
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          Set<String> _savedItems = {};
          print(_saved.length);
          _saved.forEach((WordPair p) {
              _savedItems.add(p.asPascalCase);
            }
          );
          print(_savedItems.length);

          return Detail(_savedItems);         
        }
      )
    );
  }
}