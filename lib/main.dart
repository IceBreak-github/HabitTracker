import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/logic/services/notification_service.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:habit_tracker/shared/shared_preferences.dart';
import 'package:habit_tracker/shared/themes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

const taskName = 'notificationPlanner';
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'notificationPlanner':
        try {
          //Task Logic here
          Map<String, String> allNotifications = (json.decode(inputData?['allNotifications']) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as String)
          );
          await NotificationService.notificationPlanner(allNotifications: allNotifications);
        } catch (err) {
          throw Exception(err); 
        }
        break;
      default:
    }
    return Future.value(true);
  });
}

void _listenForUpdatesFromWorkManager() {
    var port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, "notificationPlanner");
    port.listen((dynamic data) async {    
      String habitName = data[0];
      Map<String, int> schedule = data[1];
      String time = data[2];
      dynamic recurrence = data[3]; 
      print('saving schedule: $schedule');
      StoredNotifications.saveNotification(habitName: habitName, schedule: schedule, time: time, recurrence: recurrence);
      for(String date in schedule.keys){
        List<String> timeParts = time.split(':');
        List<String> dateParts = date.split('.');
        NotificationService.createCalendarNotification(       //creates the notification for another week in the future
          id: schedule[date]!,
          day: int.parse(dateParts[2]),
          month: int.parse(dateParts[1]),
          year: int.parse(dateParts[0]),
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
          title: habitName,
          body: "Don't forget to complete your Habit !",
        );
      }
    });
  }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.initializeNotification();
  Hive.registerAdapter(HabitAdapter());
  boxHabits = await Hive.openBox<Habit>('habitBox');
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);           //TODO later set to false
  _listenForUpdatesFromWorkManager();
  runApp(const MyApp());
  /*
  Map<String, String> allNotifications = await StoredNotifications.getAllPrefs();
  Workmanager().registerPeriodicTask('notificationPlanner', taskName, frequency: const Duration(days: 3), inputData: <String, dynamic>{
      'allNotifications': json.encode(allNotifications),
  });
  */ //TODO uncomment later

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HabitHomeCubit>(
          create: (context) => HabitHomeCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Habit Tracker",
        theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: MyColors().backgroundColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          timePickerTheme: MyThemes().timePickerTheme,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: MyColors().primaryColor,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
