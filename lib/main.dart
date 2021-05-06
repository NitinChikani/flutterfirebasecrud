import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './widget/Register.dart';
import './widget/Register_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Tabs Demo'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_box_outlined)),
                Tab(
                  icon: Icon(Icons.verified),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Register(),
              RegisterList(),
            ],
          ),
        ),
      ),
    );
  }
}
