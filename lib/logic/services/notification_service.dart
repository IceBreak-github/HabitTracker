import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:habit_tracker/shared/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,  //TODO: for the logo, change later
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Habit Tracker notifications',
          channelDescription: 'Notifications channel for Habit Tracker',
          defaultColor: MyColors().primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.Max, 
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: 'high_importance_channel_group', channelGroupName: 'Group 1')
      ],
      debug: false,
    );
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod

    );
  }
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async{
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) {
          return const HomePage();
        })
      );
    }
  }

  static Future<void> createCalendarNotification({
    required final int id,
    required final String title,
    required final String body,
    required final int hour,
    required final int minute,
    required final int day,
    required final int month,
    required final int year,

  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, //title.hashCode,   //UniqueKey().hashCode,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: ActionType.Default,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        day: day,
        month: month,
        year: year,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true
      )
    );
  }

  static Future<void> notificationPlanner({              //running on the workmanager isolate
    required Map<String, String> allNotifications,
  }) async {
    if(allNotifications.isEmpty){
      return;
    }
    for(String habitName in allNotifications.keys){
      //getting data
      List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habitName);
      Map<String, int> decodedSchedule = sharedPreferencesValues[0];
      String time = sharedPreferencesValues[1]; 
      dynamic recurrence = sharedPreferencesValues[2];
      print('My decoded schedule is $decodedSchedule'); 

      //cleaning
      List<String> keysToRemove = [];
      for (String date in decodedSchedule.keys){                                           
        List<String> dateParts = date.split('.');
        if(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])).isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))){          //if notification date is before current, remove it since its not needed anymore
          keysToRemove.add(date);                                       
        }
      }
      keysToRemove.forEach((key) => decodedSchedule.remove(key));

      //planning future notifications
      if(recurrence == 'Every Day'){                       //if habit recurrence is everyday
        List<DateTime> dateList = decodedSchedule.keys.toList().map((dateString) {
          List<String> dateParts = dateString.split('.');
          return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
        }).toList();
        DateTime mostFutureDate = dateList.reduce((a, b) => a.isAfter(b) ? a : b);          //find the most future date
        DateTime mostPastDate = dateList.reduce((a, b) => a.isBefore(b) ? a : b);                              
        if(!decodedSchedule.containsKey(DateFormat('yyyy.M.d').format(mostPastDate.add(const Duration(days: 8))))){              //if a notification 8 days ahead is planned, the script already ran
          for(int i = 0; i < 7; i++){                     //plans the notifications another 7 days ahead, O(1)
            int scheduleId = const Uuid().v4().hashCode;
            DateTime futureDate = mostFutureDate.add(Duration(days: i));
            decodedSchedule[DateFormat('yyyy.M.d').format(futureDate)] = scheduleId;
          }
        }
        print('Sending schedule: $decodedSchedule');
        SendPort? send = IsolateNameServer.lookupPortByName('notificationPlanner');
        send?.send([habitName, decodedSchedule, time, recurrence]);
      }
    }
  }

  static Future<Map<String, int>> initalNotificationCreation({required dynamic recurrence, required DateTime startDate, required String habitName, required String time}) async {   //creates first 7 notifications when habit is created
    Map<String, int> scheduleIds = {};
    List<String> timeParts = time.split(':');
    if(recurrence == null) {      //create a one time notification
      print(recurrence);
      int scheduleId = const Uuid().v4().hashCode;
      NotificationService.createCalendarNotification(
        id: scheduleId,
        day: startDate.day,
        month: startDate.month,
        year: startDate.year,
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
        title: habitName,
        body: "Don't forget to complete your Habit !",
      );
      scheduleIds[DateFormat('yyyy.M.d').format(startDate)] = scheduleId;
      return scheduleIds;
    }
    if(recurrence is String && recurrence == 'Every Day'){
      for(int i = 0; i < 7; i++){                     //plans the notifications 7 days ahead
        int scheduleId = const Uuid().v4().hashCode;
        DateTime thisDate = startDate.add(Duration(days: i));
        NotificationService.createCalendarNotification(
          id: scheduleId,
          day: thisDate.day,
          month: thisDate.month,
          year: thisDate.year,
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
          title: habitName,
          body: "Don't forget to complete your Habit !",
        );
        scheduleIds[DateFormat('yyyy.M.d').format(thisDate)] = scheduleId; 
      }
      return scheduleIds;
    }
    if(recurrence is Map){
      if(recurrence.containsKey("interval")){

      }
      else if(recurrence.containsKey("Monday")){

      }
      if (recurrence.keys.every((key) => key is int)){

      }
    }
    return scheduleIds;
  }
   
}