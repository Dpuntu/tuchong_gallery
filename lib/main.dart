import 'package:flutter/material.dart';
import 'package:tuchong/pages/HomePager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '图虫',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePager());
  }
}
