
Map<String,String>? lang;
List<Calendar> calendars = [];

class Calendar {

  String? date;
  String type;
  String url;

  static void setLang(Map<String,String> langMap) {
    lang = langMap;
  }
  Calendar({required this.type, required this.url});
}