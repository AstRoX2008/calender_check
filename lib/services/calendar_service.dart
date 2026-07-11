import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map<String,dynamic>? lang;
Map<String, Calendar> calendars = {};
DateTime curDate = DateTime.now();

class Calendar {

  String? day;
  String? month;
  String? year;
  String? dayString;
  String? monthString;
  Map<String, dynamic>? timings;
  String type;
  List<dynamic> days = [];
  dynamic curDayData;
  int deepSeatedMonth = -1;

  Widget dateWidget(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(day ?? '--', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold)),
        Text(monthString ?? month ?? '--', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
        Text(year ?? '--', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      ],
    );
  
  Future<void> fetch() async {
    try {
        switch (type) {
          case 'Gregorian':
            day = curDate.day.toString();
            month = curDate.month.toString();
            year ='${curDate.year.toString()} م';
            dayString = DateFormat('EEEE').format(curDate);
            monthString = DateFormat('MMMM').format(curDate);
            monthString = lang?[monthString] ?? monthString;
            break;
          case 'Hijri':
          // https://api.aladhan.com/v1/calendarByCity/2026/7?city=Cairo&country=Egypt&method=5
          // https://api.aladhan.com/v1/timingsByAddress/${DateFormat('dd-MM-yyyy').format(curDate)}?address=Cairo&method=5
            if(deepSeatedMonth != curDate.month){
              final response = await http.get(Uri.parse('https://api.aladhan.com/v1/calendarByCity/${curDate.year}/${curDate.month}?city=Cairo&country=Egypt&method=5'));
              if (response.statusCode == 200) {
                final jsonData = jsonDecode(response.body);
                days = jsonData['data'];
                //debugPrint(jsonData);
              }
            }
            
            curDayData = days[int.parse(calendars["Gregorian"]!.day ?? '1') - 1];
            day = curDayData['date']['hijri']['day'];
            month = curDayData['date']['hijri']['month']['number'].toString();
            year = curDayData['date']['hijri']['year'] + ' هـ';
            dayString = curDayData['date']['hijri']['weekday']['ar'];
            monthString = curDayData['date']['hijri']['month']['ar'];
            timings = curDayData['timings'];
            timings?.removeWhere((key, value) => key == 'Sunset' || key == 'Imsak' || key == 'Midnight' || key == 'Firstthird' || key == 'Lastthird');
            deepSeatedMonth = curDate.month;
            break;
          case 'Coptic':
            if(deepSeatedMonth != curDate.month){
            
              final response = await http.get(Uri.parse('https://api.coptic.io/api/calendar/month/${curDate.year}/${curDate.month}'));
              if (response.statusCode == 200) {
                final jsonData = jsonDecode(response.body);
                days = jsonData['days'];
              }
            }
            curDayData = days[int.parse(calendars["Gregorian"]!.day ?? '1') - 1]['copticDate'];
            day = curDayData['day'].toString();
            month = curDayData['month'].toString();
            year = '${curDayData['year']} ق';
            monthString = curDayData['monthString'];
            monthString = lang?[monthString] ?? monthString;
            deepSeatedMonth = curDate.month;
            break;
          default:
            debugPrint('Unknown calendar type: $type');
        }
    } catch (e) {
      debugPrint('Error fetching calendar data: $e');
    }
  }

  static void setLang(Map<String,dynamic> langMap) {
    lang = langMap;
  }
  Calendar({required this.type});
}