import 'package:flutter/material.dart';
import 'package:hello/home.dart';

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
