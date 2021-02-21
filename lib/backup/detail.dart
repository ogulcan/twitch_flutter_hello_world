import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  
  Set<String> saved = <String>{};

  Detail(Set<String> savedItems) {
    this.saved = savedItems;
  }

  @override
  _DetailState createState() => _DetailState(); 
}

class _DetailState extends State<Detail> {

  @override
  Widget build(BuildContext context) {
    this.widget.saved.add("AAA");

    final tiles = this.widget.saved.map(
      (String word) {
        return ListTile(
          title: Text(
            word,
          ),
        );
      },
    );
    final divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved suggestions'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: onIconPressed, tooltip: "AAAAA"),
        ],
      ),
      body: ListView(children: divided),
    );          
  }

  void onIconPressed() {

  }
}
