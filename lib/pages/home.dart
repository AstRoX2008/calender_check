import 'package:flutter/material.dart';
import 'package:calender_check/services/calendar_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('صلي على النبي',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calendars['Gregorian']?.dateWidget() ?? Text('Loading...'),
                calendars['Hijri']?.dateWidget() ?? Text('Loading...'),
              ],
            ),
            calendars['Coptic']?.dateWidget() ?? Text('Loading...'),
          ],
        ),
      ),
    );
  }
}