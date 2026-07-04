import 'package:flutter/material.dart';
import 'package:calender_check/pages/home.dart';
import 'package:calender_check/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      '/home': (context) => Home(),
      '/': (context) => Loading(),
    },
  ));
}