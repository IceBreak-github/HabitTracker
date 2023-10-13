import 'package:flutter/material.dart';
import 'package:habit_tracker/shared/colors.dart';

class MyThemes{
  final timePickerTheme = TimePickerThemeData(              // TODO: Finish styling tha clock window
        backgroundColor: MyColors().widgetColor,
        hourMinuteShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        dayPeriodBorderSide: BorderSide(color: MyColors().backgroundColor, width: 4),
        dayPeriodColor: MyColors().backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected) ? MyColors().secondaryColor : MyColors().lightGrey),
        dayPeriodShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          //side: BorderSide(color: Colors.orange, width: 4),
        ),
        hourMinuteColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected) ? MyColors().backgroundColor : MyColors().backgroundColor),
        hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? MyColors().primaryColor : Colors.white),
        dialHandColor: const Color.fromRGBO(39,39,51,1),
        dialBackgroundColor: MyColors().backgroundColor,
        hourMinuteTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        dayPeriodTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        helpTextStyle:const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        dialTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? MyColors().primaryColor : Colors.white),
        entryModeIconColor: MyColors().secondaryColor,
  );
}