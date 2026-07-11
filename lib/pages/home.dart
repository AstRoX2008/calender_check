import 'package:flutter/material.dart';
import 'package:calender_check/services/calendar_service.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
  Color textColor = const Color.fromARGB(255, 255, 255, 255);
class _HomeState extends State<Home> {
  bool clickable = true;
  void changeDate(String arrow) async {
    if (!clickable) return;
    clickable = false;
    curDate = arrow == 'left' ? curDate.subtract(Duration(days: 1)) : curDate.add(Duration(days: 1));
      final futures = calendars.entries.map((entry) {
        return entry.value.fetch();
      });
      await Future.wait(futures);
    setState(() {
      curDate = curDate;
    });
    clickable = true;
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 14, 31),
      appBar: AppBar(
        title:  Center(
          child: Text('صلي على النبي',style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08,fontWeight: FontWeight.bold,color: textColor)),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 113, 151),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(calendars['Hijri']?.dayString ?? 'Loading...', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold,color: textColor)),
            Text(calendars['Gregorian']?.dayString ?? 'Loading...', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,color: textColor)),
            SizedBox(height: MediaQuery.of(context).size.width * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calendars['Gregorian']?.dateWidget(context) ?? Text('Loading...',style: TextStyle(color: textColor)),
                calendars['Hijri']?.dateWidget(context) ?? Text('Loading...',style: TextStyle(color: textColor)),
              ],
            ),
            calendars['Coptic']?.dateWidget(context) ?? Text('Loading...',style: TextStyle(color: textColor)),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: calendars['Hijri']?.timings?.entries.map((entry) {
                return Text('${lang?[entry.key] ?? entry.key} :  ${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(entry.value)).replaceAll('AM', 'ص')
                .replaceAll('PM', 'م')}', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08,color: textColor));
              }).toList() ?? [Text('Loading...',style: TextStyle(color: textColor))],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(onPressed: () => changeDate("left"),icon: Icon(Icons.arrow_left,size: MediaQuery.of(context).size.width * 0.1,),label: Text('السابق',style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),),),
                FloatingActionButton.extended(onPressed: () => changeDate("right"),icon: Icon(Icons.arrow_right,size: MediaQuery.of(context).size.width * 0.1,),label: Text('التالي',style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),),),
              ]
            )
          ]
        ),
      )
      ),
    )

      ) 
    );
  }
}

/*

*/