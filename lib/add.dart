import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hello/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

typedef VoidCallback = void Function();

class AddPage extends StatefulWidget {

  static final String todoKey = "todo";
  static final String doneKey = "done";

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<String> list = [];
  
  var _hasError = false;
  var _borderSideColor = BorderSide(color: Colors.yellow, width: 3.0);
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Add new to-do"),
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: () { print("Tapped"); },
            child:Column(
              children: <Widget>[
              TextFormField(
                onChanged: (text) {
                  if (_hasError == false) return;
                  setState(() {
                    _hasError = false;
                    _borderSideColor = BorderSide(color: Colors.yellow, width: 3.0);      
                  });
                },
                key: _formKey, decoration: 
                InputDecoration(
                  labelText: "New to-do",
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: _borderSideColor,
                  ),
                ),
              ),
              Container(child:
                Row(
                  children: <Widget>[
                    Expanded(child:
                      RaisedButton(
                        child: Text("Add Item"),
                        textTheme: ButtonTextTheme.primary,
                        onPressed: () => _onPressButton(context)
                      )
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 20.0),
              )
            ],
            )
          )
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      )
    );
  }

  Future<void> _onPressButton(BuildContext context) async {
    var text = _formKey.currentState.value.toString();
    
    if (text.isEmpty) {
      Flushbar(title: "Caution", 
        message: "Empty text not allowed", 
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 3)).show(context);

      setState(() {
        _hasError = true;
        _borderSideColor = BorderSide(color: Colors.red, width: 3.0);
      });
    } else {
      //await _saveItem(text);
      _saveTodo(text, () {
        Navigator.of(context).pop();
      });
    }
  }

  void _saveTodo(String text, VoidCallback callback) async {
    var todoItem = Todo(text);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var todoItems = [];
    var todoItemsString = prefs.getString(AddPage.todoKey);
    if (todoItemsString != null) {
      List<dynamic> dynamicItems = jsonDecode(todoItemsString);
      todoItems = dynamicItems.cast<String>();
    }

    todoItems.add(todoItem.toJsonString());
    todoItemsString = jsonEncode(todoItems);
    await prefs.setString(AddPage.todoKey, todoItemsString);

    callback();
  }

  // Future<void> _saveItem(text) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var items = [];
  //   var itemsString = prefs.getString("items");
  //   if (itemsString != null) {
  //     List<dynamic> dynamicItems = jsonDecode(itemsString);
  //     items = dynamicItems.cast<String>();
  //   }
  //   items.add(text);
  //   itemsString = jsonEncode(items);
  //   await prefs.setString("items", itemsString);
  // }
}