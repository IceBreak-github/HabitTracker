import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/logic/services/notification_service.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
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
          await NotificationService.initializeNotification();
          await NotificationService.notificationPlanner();
        } catch (err) {
          throw Exception(err); 
        }
        break;
      default:
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.initializeNotification();
  Hive.registerAdapter(HabitAdapter());
  boxHabits = await Hive.openBox<Habit>('habitBox');
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);           //TODO later set to false
  runApp(const MyApp());
  
  Workmanager().registerPeriodicTask('notificationPlanner', taskName, frequency: const Duration(days: 1));

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
          dialogBackgroundColor: MyColors().widgetColor,
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
          textTheme: TextTheme(
            bodyLarge: const TextStyle(fontSize: 14, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 12, color: MyColors().lightGrey),
            titleLarge: const TextStyle(fontSize: 14, color: Colors.white),
            titleMedium: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500), 
          ),
          canvasColor: const Color.fromRGBO(20, 20, 20, 1),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              elevation: MaterialStateProperty.all(0),
              overlayColor: MaterialStateProperty.all(MyColors().primaryColor.withOpacity(0.1)),
              foregroundColor: MaterialStateProperty.all(MyColors().primaryColor),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
