import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/logic/services/habit_service.dart';
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
        criticalAlert: true,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        day: day,
        month: month,
        year: year,
        second: 1,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true,
        allowWhileIdle: true,
      )
    );
  }

  static Future<void> notificationPlanner() async {
    Map<String, String> allNotifications = await StoredNotifications.getAllPrefs();
    if(allNotifications.isEmpty){
      return;
    }
    for(String habitName in allNotifications.keys){
      //getting data
      List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habitName);
      Map<String, int> decodedSchedule = sharedPreferencesValues[0];
      String time = sharedPreferencesValues[1]; 
      dynamic recurrence = sharedPreferencesValues[2];
      Map<String, int> decodedStartDateMap = sharedPreferencesValues[3];
      print('My decoded schedule is $decodedSchedule'); 

      if(decodedSchedule.isNotEmpty){
        List<String> keysToRemove = [];
        for (String date in decodedSchedule.keys){                                           
          List<String> dateParts = date.split('.');
          if(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])).isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))){          //if notification date is before current, remove it since its not needed anymore
            keysToRemove.add(date);                                       
          }
        }
        keysToRemove.forEach((key) => decodedSchedule.remove(key));
      }
      for(int i = 0; i < 3; i++){
        DateTime thisDate = DateTime.now().add(Duration(days: i));
        bool show = showHabitOrNot(recurrence: recurrence, habitDate: decodedStartDateMap, newDate: thisDate);
        if(!decodedSchedule.containsKey(DateFormat('yyyy.M.d').format(thisDate))){
          if(show){
            int scheduleId = const Uuid().v4().hashCode;
            decodedSchedule[DateFormat('yyyy.M.d').format(thisDate)] = scheduleId;
          }
        }
      }

      await StoredNotifications.saveNotification(habitName: habitName, schedule: decodedSchedule, time: time, recurrence: recurrence, startDate: DateTime(decodedStartDateMap['year']!, decodedStartDateMap['month']!, decodedStartDateMap['day']!));
      for(String date in decodedSchedule.keys){
        List<String> timeParts = time.split(':');
        List<String> dateParts = date.split('.');
        await NotificationService.createCalendarNotification(       //re-schedules the notification in the future
          id: decodedSchedule[date]!,
          day: int.parse(dateParts[2]),
          month: int.parse(dateParts[1]),
          year: int.parse(dateParts[0]),
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
          title: habitName,
          body: "Don't forget to complete your Habit !",
        );
      }
    }
  }
  
  static Future<Map<String, int>> initalNotificationCreation({required dynamic recurrence, required DateTime startDate, required String habitName, required String time}) async {   //creates first 7 notifications when habit is created
    Map<String, int> scheduleIds = {};
    List<String> timeParts = time.split(':');
    Map<String, int> startDateMap = {'year' : startDate.year, 'month' : startDate.month, 'day' : startDate.day};
    bool isBefore = startDate.isBefore(DateTime.now());
    if(recurrence == null) {      //create a one time notification
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
    for(int i = 0; i < 2; i++){                     //plans the notifications 2 dates ahead
      int scheduleId = const Uuid().v4().hashCode;
      DateTime thisDate = isBefore ? DateTime.now().add(Duration(days: i)) : startDate.add(Duration(days: i));
      bool show = showHabitOrNot(recurrence: recurrence, habitDate: startDateMap, newDate: thisDate);
      if(show){
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
    }
    return scheduleIds;
  }
}