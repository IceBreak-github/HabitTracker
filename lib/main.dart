import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:habit_tracker/shared/themes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  boxHabits = await Hive.openBox<Habit>('habitBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
