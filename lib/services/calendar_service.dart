import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String,dynamic>? lang;
Map<String, Calendar> calendars = {};

class Calendar {

  String? day;
  String? month;
  String? year;
  String? dayString;
  String? monthString;
  String type;
  String url;

  Widget dateWidget() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(day ?? '--', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
        Text(monthString ?? month ?? '--', style: TextStyle(fontSize: 20)),
        Text(year ?? '--', style: TextStyle(fontSize: 30)),
      ],
    );
  
  Future<void> fetch() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        switch (type) {
          case 'Gregorian':
            day = jsonData['data']['date']['gregorian']['day'];
            month = jsonData['data']['date']['gregorian']['month']['number'].toString();
            year = jsonData['data']['date']['gregorian']['year'];
            dayString = jsonData['data']['date']['gregorian']['weekday']['en'];
            monthString = jsonData['data']['date']['gregorian']['month']['en'];
            monthString = lang![monthString] ?? monthString;
            break;
          case 'Hijri':
            day = jsonData['data']['date']['hijri']['day'];
            month = jsonData['data']['date']['hijri']['month']['number'].toString();
            year = jsonData['data']['date']['hijri']['year'];
            dayString = jsonData['data']['date']['hijri']['weekday']['ar'];
            monthString = jsonData['data']['date']['hijri']['month']['ar'];
            break;
          case 'Coptic':
            day = jsonData['day'].toString();
            month = jsonData['month'].toString();
            year = jsonData['year'].toString();
            monthString = jsonData['monthString'];
            monthString = lang![monthString] ?? monthString;
            break;
          default:
            debugPrint('Unknown calendar type: $type');
        }
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