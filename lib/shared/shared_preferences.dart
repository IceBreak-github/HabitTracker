import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoredNotifications{
  
  static Future<Map<String, String>> getAllPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return <String, String>{
      for (String key in prefs.getKeys()) ...{key: prefs.get(key).toString()}
    };
  }

  static Future<bool> saveNotification({required String habitName, required Map<String, int> schedule, required String time, required dynamic recurrence}) async {            //TODO later change to habit ID
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String encodedSchedule = json.encode(schedule);
    String encodedRecurrence;
    if(recurrence is Map){
      encodedRecurrence = json.encode(recurrence);
    }
    if(recurrence == null){
      encodedRecurrence = 'null';
    }
    else{
      encodedRecurrence = recurrence;
    }
    List<String> values = [encodedSchedule, time, encodedRecurrence];
    String encodedValues = json.encode(values);
    return prefs.setString(habitName, encodedValues);
  }

  static Future<List> decodeSharedPreferences({required String name}) async {
    List<String> decodeJsonList(String jsonList) {
      List<dynamic> decodedList = jsonDecode(jsonList);
      return decodedList.map((item) => item.toString()).toList();
    }
    Map<String, String> allNotifications = await StoredNotifications.getAllPrefs();
    List<String> decodedValues = decodeJsonList(allNotifications[name]!);
    Map<String, int> decodedSchedule = (json.decode(decodedValues[0]) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as int)
    );
    String time = decodedValues[1];
    dynamic recurrence = decodedValues[2];
    return [decodedSchedule, time, recurrence];
  }
}