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
  String url;

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
            final response = await http.get(Uri.parse('$url${DateFormat('dd-MM-yyyy').format(curDate)}?address=Cairo&method=5'));
            if (response.statusCode == 200) {
              final jsonData = jsonDecode(response.body);
              day = jsonData['data']['date']['hijri']['day'];
              month = jsonData['data']['date']['hijri']['month']['number'].toString();
              year = jsonData['data']['date']['hijri']['year'] + ' هـ';
              dayString = jsonData['data']['date']['hijri']['weekday']['ar'];
              monthString = jsonData['data']['date']['hijri']['month']['ar'];
              timings = jsonData['data']['timings'];
              timings?.removeWhere((key, value) => key == 'Sunset' || key == 'Imsak' || key == 'Midnight' || key == 'Firstthird' || key == 'Lastthird');
            }
            break;
          case 'Coptic':
            final response = await http.get(Uri.parse('$url${DateFormat('yyyy-MM-dd').format(curDate)}'));
            if (response.statusCode == 200) {
              final jsonData = jsonDecode(response.body);
              day = jsonData['day'].toString();
              month = jsonData['month'].toString();
              year = '${jsonData['year']} ق';
              monthString = jsonData['monthString'];
              monthString = lang?[monthString] ?? monthString;
            }
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
  Calendar({required this.type, required this.url});
}