import 'package:flutter/material.dart';
import 'babymonitor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BabyMonitorSoS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BabyMonitorPage(),
    );
  }
}
