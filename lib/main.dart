import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/today_page.dart';
import 'package:habit_tracker/shared/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _timePickerTheme = TimePickerThemeData(              // TODO: Finish styling tha clock window
      backgroundColor: Constants().widgetColor,
      hourMinuteShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      dayPeriodBorderSide: BorderSide(color: Constants().backgroundColor, width: 4),
      dayPeriodColor: Constants().backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected) ? Constants().secondaryColor : Constants().lightGrey),
      dayPeriodShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        //side: BorderSide(color: Colors.orange, width: 4),
      ),
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected) ? Constants().backgroundColor : Constants().backgroundColor),
      hourMinuteTextColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.selected) ? Constants().primaryColor : Colors.white),
      dialHandColor: const Color.fromRGBO(39,39,51,1),
      dialBackgroundColor: Constants().backgroundColor,
      hourMinuteTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      dayPeriodTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      helpTextStyle:const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      dialTextColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.selected) ? Constants().primaryColor : Colors.white),
      entryModeIconColor: Constants().secondaryColor,
    );

    return MaterialApp(
      title: "Habit Tracker",
      theme: ThemeData(fontFamily: 'Montserrat', scaffoldBackgroundColor: Constants().backgroundColor, splashColor: Colors.transparent, highlightColor: Colors.transparent,
      timePickerTheme: _timePickerTheme,
      textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        /*
        side: BorderSide(
          width: 1.5,
          color: Constants().primaryColor,
        ),
        */
        foregroundColor: Constants().primaryColor,
      ),
    ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TodayPage(),
    );
  }
}

