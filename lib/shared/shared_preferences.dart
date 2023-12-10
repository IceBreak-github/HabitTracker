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
    else{
      encodedRecurrence = recurrence;
    }
    List<String> values = [encodedSchedule, time, encodedRecurrence];
    String encodedValues = json.encode(values);
    return prefs.setString(habitName, encodedValues);
  }
}