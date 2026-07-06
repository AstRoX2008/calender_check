import 'package:flutter/material.dart';
import 'package:calender_check/services/calendar_service.dart';
import 'package:intl/intl.dart';

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
      body: Scrollbar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(calendars['Hijri']?.dayString ?? 'Loading...', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold)),
            Text(calendars['Gregorian']?.dayString ?? 'Loading...', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calendars['Gregorian']?.dateWidget(context) ?? Text('Loading...'),
                calendars['Hijri']?.dateWidget(context) ?? Text('Loading...'),
              ],
            ),
            calendars['Coptic']?.dateWidget(context) ?? Text('Loading...'),
            SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: calendars['Hijri']?.timings?.entries.map((entry) {
                return Text('${lang?[entry.key] ?? entry.key} :  ${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(entry.value)).replaceAll('AM', 'ص')
                .replaceAll('PM', 'م')}', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08));
              }).toList() ?? [Text('Loading...')],
            ),
          ]
        )
      )
    );
  }
}