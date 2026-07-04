import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:calender_check/services/calendar_service.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future<void> setCalenders() async {
    try {
    String langString = await rootBundle.loadString('lib/data/lang-ar.json');
    final dynamic lang = jsonDecode(langString);
    if (lang is Map<String,dynamic>) {
      Calendar.setLang(lang);
    } else {
      debugPrint('Unexpected JSON format.');
    }

    String urlsString = await rootBundle.loadString('lib/data/urls.json');
    final dynamic urls = jsonDecode(urlsString);
    if (urls is Map) {
      calendars.clear();

      final futures = urls.entries.map((entry) {
        final curCal = Calendar(type: entry.key, url: entry.value);
        calendars[entry.key] = curCal;
        return curCal.fetch();
      });
      await Future.wait(futures);

    } else {
      debugPrint('Unexpected JSON format.');
    }
  } on FormatException catch (e) {
    debugPrint('Error: Invalid JSON format. ${e.message}');
  } on IOException catch (e) {
    debugPrint('File read error: $e');
  } catch (e) {
    debugPrint('Unexpected error: $e');
  }
  if (!mounted) return; 
  Navigator.pushReplacementNamed(context, '/home');
  }
  @override
  void initState() {
    super.initState();

    setCalenders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: const Color.fromARGB(255, 191, 119, 250),),
        ),
      );
  }
}