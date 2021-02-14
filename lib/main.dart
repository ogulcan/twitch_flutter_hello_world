import 'package:flutter/material.dart';
import 'package:hello/add.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyTodoListApp());

class MyTodoListApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To-do",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(children: <Widget>[
            MyAppBar(),
            Expanded(child: 
              ListWidget(items),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add', // used by assistive technologies
          child: Icon(Icons.add),
          onPressed: () => _pushAddPage(context),
        ),
      )
    );
  }

  Future<void> _pushAddPage(BuildContext context) async {
    final value = await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AddPage();
        }
      )
    );
    getItems().then((i) {
      items = i;
      setState(() {
        
      });
    });
    // getItems().then((i) ({
    //   setState((i) {
    //     items = i;
    //   })
    // }));
  }

  Future<List<String>> getItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var itemsString = prefs.getString("items");
    var items = [];
    if (itemsString != null) {
      List<dynamic> dynamicItems = jsonDecode(itemsString);
      items = dynamicItems.cast<String>();
    }
    print(items.length);
    return items;
  }
}

class ListWidget extends StatefulWidget {
  List<String> items = [];

  ListWidget(List<String> items) {
    this.items = items;
  }

  @override
  _ListWidgetState createState() => _ListWidgetState(); 
}

class _ListWidgetState extends State<ListWidget> {

  @override
  Widget build(BuildContext context) {
    final tiles = this.widget.items.map(
      (String word) {
        return ListTile(
          title: Text(
            word,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
    return ListView(children: divided);
  }
}

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(color: Colors.blue[800]),
      child: Row(children: <Widget>
      [
        Expanded(child: Text("To-dos", style: TextStyle(color: Colors.white, fontSize: 20.0))),
        //IconButton(color: Colors.white, icon: Icon(Icons.add), onPressed: null),
      ]),
    );
  }
}