import 'package:flutter/material.dart';
import 'package:hello/add.dart';
import 'package:hello/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

typedef ListValue = void Function(List<Todo> items, List<Todo> doneItems);

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> items = [];
  List<Todo> doneItems = [];

  @override
  void initState() {
    super.initState();
    updateItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(children: <Widget>[
            MyAppBar(items.length),
            Expanded(child: 
              ListWidget(items, doneItems)
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
    updateItems();
  }

  void getItems(ListValue callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var itemsString = prefs.getString(AddPage.todoKey);
    var doneItemsString = prefs.getString(AddPage.doneKey);

    List<Todo> items = [];
    if (itemsString != null) {
      List<String> dynamicItems = jsonDecode(itemsString).cast<String>();
      dynamicItems.forEach((json) {
        Todo item = Todo.fromJson(jsonDecode(json));
        items.add(item);
      });
    }

    List<Todo> doneItems = [];
    if (doneItemsString != null) {
      List<String> dynamicItems = jsonDecode(doneItemsString).cast<String>();
      dynamicItems.forEach((json) {
        Todo item = Todo.fromJson(jsonDecode(json));
        doneItems.add(item);
      });
    }

    callback(items, doneItems);
  }

  void updateItems() {
    getItems((items, doneItems) {
      this.items = items;
      this.doneItems = doneItems;
      setState(() {

      });
    });
  }
}

class ListWidget extends StatefulWidget {
  List<Todo> items = [];
  List<Todo> doneItems = [];

  ListWidget(this.items, this.doneItems);

  @override
  _ListWidgetState createState() => _ListWidgetState(); 
}

class _ListWidgetState extends State<ListWidget> {

  @override
  Widget build(BuildContext context) {
    _storeItems();
    var headTodoItem = HeadingItem("To-dos (${this.widget.items.length})");
    var headDoneItem = HeadingItem("Done (${this.widget.doneItems.length})");
    
    List<ListItem> listItems = [];
    listItems.add(headTodoItem);
    listItems.addAll(this.widget.items.map(
      (Todo item) {
        return MessageItem(item, MessageType.todo);
      }
    ));
    listItems.add(headDoneItem);
    listItems.addAll(this.widget.doneItems.map(
      (Todo item) {
        return MessageItem(item, MessageType.done);
      }
    ));

    final tiles = listItems.map(
      (ListItem listItem) {
        var column = Column(children: [
          ListTile(
            title: listItem.buildTitle(context),
            enabled:listItem.clickable(),
            onTap: () {
              _changeItemType(listItem.getType(), listItem.getUniqueId());
            },
          ),
        ]);

        if (listItem.getUniqueId() == null) {
          column.children.add(Divider(thickness: 2));
        }
        
        return column;
      },
    );

    return ListView(children: tiles.toList());
  }

  void _changeItemType(MessageType type, int id) {
    if (type == MessageType.todo) {
      this.widget.items = this.widget.items.where((item) {
        if (item.timestamp == id) this.widget.doneItems.add(item);
        return (item.timestamp != id);
      }).toList();
    } else if (type == MessageType.done) {
      this.widget.doneItems = this.widget.doneItems.where((item) {
        if (item.timestamp == id) this.widget.items.add(item);
        return (item.timestamp != id);
      }).toList();
    }

    setState(() {});
  }

  void _storeItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var items = [];
    this.widget.items.forEach((item) {
      items.add(item.toJsonString());
      prefs.setString(AddPage.todoKey, jsonEncode(items));
    });

    var todoItems = [];
    this.widget.doneItems.forEach((item) {
      todoItems.add(item.toJsonString());
      prefs.setString(AddPage.doneKey, jsonEncode(todoItems));
    });
  }
}

class MyAppBar extends StatelessWidget {

  int size;

  MyAppBar(int size) {
    this.size = size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(color: Colors.blue[800]),
      child: Row(children: <Widget>
      [
        Expanded(child: Text("To-dos ($size)", style: TextStyle(color: Colors.white, fontSize: 20.0))),
      ]),
    );
  }
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  bool clickable();

  MessageType getType();

  int getUniqueId();
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;

  bool clickable() => false;

  MessageType getType() => null;

  int getUniqueId() => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final Todo item;
  final MessageType type;

  MessageItem(this.item, this.type);

  Widget buildTitle(BuildContext context) => Text(
    item.title,
    style: (type == MessageType.todo) ? TextStyle(color: Colors.black,) : TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
  );

  Widget buildSubtitle(BuildContext context) => null;

  bool clickable() => true;

  MessageType getType() => this.type;

  int getUniqueId() => item.timestamp;
}

enum MessageType {
  todo,
  done
}