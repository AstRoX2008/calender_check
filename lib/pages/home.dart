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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(calendars['Hijri']?.dayString ?? 'Loading...', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            Text(calendars['Gregorian']?.dayString ?? 'Loading...', style: TextStyle(fontSize: 30)),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calendars['Gregorian']?.dateWidget() ?? Text('Loading...'),
                calendars['Hijri']?.dateWidget() ?? Text('Loading...'),
              ],
            ),
            calendars['Coptic']?.dateWidget() ?? Text('Loading...'),
            SizedBox(height: 40),
            
          ],
        ), 
      );
  }
}