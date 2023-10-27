import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';
//import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
//import 'package:habit_tracker/presentation/widgets/button_widgets.dart';

import '../../shared/colors.dart';
import '../widgets/recurrence_panel_widgets.dart';
import '../widgets/widgets.dart';

class NewHabitPage extends StatefulWidget {
  final String? habitType;
  final bool trackable;
  final bool recurrent;
  const NewHabitPage(
      {super.key,
      required this.habitType,
      required this.trackable,
      required this.recurrent});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  final formKey = GlobalKey<FormState>();

  final shakeTimeKey = GlobalKey<ShakeWidgetState>();
  final shakeNameKey = GlobalKey<ShakeWidgetState>();
  final shakeGoalKey = GlobalKey<ShakeWidgetState>();
  final shakeUnitKey = GlobalKey<ShakeWidgetState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const NewHabitAppBar(),
      bottomNavigationBar: SubmitButton(
          text: 'Save Habit',
          width: MediaQuery.of(context).size.width,
          onPressed: () {
            final habitFormState = context.read<HabitFormCubit>().state;
            final habitRecurrenceState = context.read<HabitRecurrenceCubit>().state;
            String? time;
            if(habitFormState.time == null){
              time = null;
            }
            else{
              time = "${habitFormState.time!.hour}:${habitFormState.time!.minute}";
            }

            if (widget.habitType == 'Measurement') {
              if (habitFormState.habitName == null ||
                  habitFormState.habitName!.trim().isEmpty) {
                shakeNameKey.currentState?.shake();
              }
              if (habitFormState.goal == null || habitFormState.goal == 0) {
                shakeGoalKey.currentState?.shake();
              }
              if (habitFormState.unit == null || habitFormState.unit == '') {
                shakeUnitKey.currentState?.shake();
              } else {
                if (!widget.recurrent) {
                  boxHabits.add(
                    Habit(
                      habitType: 'Measurement', 
                      name: habitFormState.habitName!, 
                      time: time, 
                      notify: habitFormState.notify, 
                      date: {
                          "year" :    int.parse(DateFormat('yyyy').format(habitFormState.selectedDate!)), 
                          "month" :   int.parse(DateFormat('MM').format(habitFormState.selectedDate!)), 
                          "day" :     int.parse(DateFormat('d').format(habitFormState.selectedDate!)),
                      },
                      goal: habitFormState.goal,
                      unit: habitFormState.unit,
                      recurrence: null,
                      )
                    );
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()),);
                } else {
                  dynamic recurrence = habitFormState.recurrenceSet;
                  if(habitFormState.recurrenceSet == 'Custom W.'){
                    recurrence = habitRecurrenceState.weekDays;
                  }
                  if(habitFormState.recurrenceSet == 'Custom M.'){
                    recurrence = habitRecurrenceState.monthDays;
                  }
                  if(habitFormState.recurrenceSet.contains('Days')) {
                    recurrence = {
                      "interval" : int.parse(habitFormState.recurrenceSet.substring(6,7)),
                      "year" :    int.parse(DateFormat('yyyy').format(DateTime.now())), 
                      "month" :   int.parse(DateFormat('MM').format(DateTime.now())), 
                      "day" :     int.parse(DateFormat('d').format(DateTime.now())),
                    };
                  }
                  boxHabits.add(
                    Habit(
                      habitType: 'Measurement', 
                      name: habitFormState.habitName!, 
                      time: time, 
                      notify: habitFormState.notify, 
                      recurrence: recurrence,
                      goal: habitFormState.goal,
                      unit: habitFormState.unit,
                       date: {
                          "year" :    int.parse(DateFormat('yyyy').format(habitFormState.selectedDate!)), 
                          "month" :   int.parse(DateFormat('MM').format(habitFormState.selectedDate!)), 
                          "day" :     int.parse(DateFormat('d').format(habitFormState.selectedDate!)),
                      }
                    )
                  );
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()),);
                }
              }
            }
            if (widget.habitType == 'Yes or No') {
              if (habitFormState.habitName == null ||
                  habitFormState.habitName!.trim().isEmpty) {
                shakeNameKey.currentState?.shake();
              } else {
                if (!widget.recurrent) {
                  boxHabits.add(Habit(habitType: 'Yes or No', name: habitFormState.habitName!, time: time, notify: habitFormState.notify, recurrence: null ,date: {
                          "year" :    int.parse(DateFormat('yyyy').format(habitFormState.selectedDate!)), 
                          "month" :   int.parse(DateFormat('MM').format(habitFormState.selectedDate!)), 
                          "day" :     int.parse(DateFormat('d').format(habitFormState.selectedDate!)),
                      },));
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()),);
                } else {
                  dynamic recurrence = habitFormState.recurrenceSet;
                  if(habitFormState.recurrenceSet == 'Custom W.'){
                    recurrence = habitRecurrenceState.weekDays;
                  }
                  if(habitFormState.recurrenceSet == 'Custom M.'){
                    recurrence = habitRecurrenceState.monthDays;
                  }
                  if(habitFormState.recurrenceSet.contains('Days')) {
                    recurrence = {
                      "interval" : int.parse(habitFormState.recurrenceSet.substring(6,7)),
                      "year" :    int.parse(DateFormat('yyyy').format(DateTime.now())), 
                      "month" :   int.parse(DateFormat('MM').format(DateTime.now())), 
                      "day" :     int.parse(DateFormat('d').format(DateTime.now())),
                    };
                    //recurrence = [interval, starting year, starting month, starting day]
                  }
                  boxHabits.add(Habit(habitType: 'Yes or No', name: habitFormState.habitName!, time: time, notify: habitFormState.notify, recurrence: recurrence,  date: {
                          "year" :    int.parse(DateFormat('yyyy').format(habitFormState.selectedDate!)), 
                          "month" :   int.parse(DateFormat('MM').format(habitFormState.selectedDate!)), 
                          "day" :     int.parse(DateFormat('d').format(habitFormState.selectedDate!)),
                      }));
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()),);
                }
              }
            }
          }),
      body: Stack(
        children: <Widget>[
          Column(children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ShakeMe(
                              key: shakeNameKey,
                              shakeCount: 3,
                              shakeOffset: 8,
                              shakeDuration: const Duration(milliseconds: 500),
                              child: InputWidget(
                                  text: "Name:",
                                  icon: Icons.drive_file_rename_outline_rounded,
                                  width: MediaQuery.of(context).size.width,
                                  child: TextInput(
                                      placeholder: "e.g. Meditation",
                                      name: 'Name',
                                      onChanged: (val) {
                                        context
                                            .read<HabitFormCubit>()
                                            .setHabitName(val);
                                      }),
                                  onTap: () {})),
                          Row(
                            children: [
                              ShakeMe(
                                // pass the GlobalKey as an argument
                                key: shakeTimeKey,
                                // configure the animation parameters
                                shakeCount: 3,
                                shakeOffset: 8,
                                shakeDuration:
                                    const Duration(milliseconds: 500),
                                // Add the child widget that will be animated
                                child: InputWidget(
                                    text: "Time:",
                                    icon: Icons.watch_later,
                                    width: 230,
                                    child: const TimeSelect(),
                                    onTap: () async {
                                      TimeOfDay? newTime = await showTimePicker(
                                        initialEntryMode:
                                            TimePickerEntryMode.dialOnly,
                                        context: context,
                                        initialTime: const TimeOfDay(
                                            hour: 12, minute: 12),
                                      );
                                      if (newTime != null) {
                                        context
                                            .read<HabitFormCubit>()
                                            .setHabitTime(newTime);
                                        context
                                            .read<HabitFormCubit>()
                                            .toggleHabitNotify(true);
                                        //print(time);
                                      }
                                    }),
                              ),
                              const SizedBox(width: 25),
                              const TimeDelete(),
                            ],
                          ),
                          InputWidget(
                              text: "Notify:",
                              icon: Icons.notifications_active_rounded,
                              width: 270,
                              child: NotifyToggle(shakeTimeKey: shakeTimeKey),
                              onTap: () {
                                final habitFormState =
                                    context.read<HabitFormCubit>().state;
                                bool? timeSet =
                                    habitFormState.time == null ? false : true;
                                bool notify = habitFormState.notify;

                                timeSet
                                    ? null
                                    : shakeTimeKey.currentState
                                        ?.shake(); //shake the widget when timeSet is false
                                timeSet
                                    ? context
                                        .read<HabitFormCubit>()
                                        .toggleHabitNotify(!notify)
                                    : context
                                        .read<HabitFormCubit>()
                                        .toggleHabitNotify(false);
                              }),
                          widget.recurrent
                              ? InputWidget(
                                  text: "Recurrence:",
                                  icon: Icons.change_circle,
                                  width: 310,
                                  child: const RecurrenceSelect(),
                                  onTap: () {
                                    recurrencePanel(context); 
                                  })
                              : InputWidget(
                                  text: 'Date: ',
                                  icon: Icons.calendar_month,
                                  width: 275,
                                  child: const DateSelect(),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: context
                                          .read<HabitFormCubit>()
                                          .state
                                          .selectedDate!,
                                      firstDate: DateTime(2018),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                onPrimary: Colors
                                                    .black, // selected text color
                                                onSurface: Colors.white,
                                                primary:
                                                    MyColors().primaryColor,
                                                surface:
                                                    MyColors().backgroundColor,
                                              ),
                                              dialogBackgroundColor:
                                                  MyColors().widgetColor,
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  textStyle: TextStyle(
                                                    color:
                                                        MyColors().primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                  foregroundColor: MyColors()
                                                      .primaryColor, // color of button's letters
                                                ),
                                              ),
                                            ),
                                            child: child!);
                                      },
                                    );
                                    if (pickedDate != null) {
                                      context
                                          .read<HabitFormCubit>()
                                          .setHabitDate(pickedDate);
                                    }
                                  }),
                          widget.habitType == "Measurement"
                              ? ShakeMe(
                                  key: shakeGoalKey,
                                  shakeCount: 3,
                                  shakeOffset: 8,
                                  shakeDuration:
                                      const Duration(milliseconds: 500),
                                  child: InputWidget(
                                      text: 'Goal:',
                                      icon: Icons.stars,
                                      width: 190,
                                      child: TextInput(
                                          placeholder: "e.g. 10",
                                          name: 'Goal',
                                          onChanged: (val) {
                                            if (val == '') {
                                            } else {
                                              context
                                                  .read<HabitFormCubit>()
                                                  .setHabitGoal(
                                                      double.parse(val));
                                            }
                                          }),
                                      onTap: () {}),
                                )
                              : Container(),
                          widget.habitType == "Measurement"
                              ? ShakeMe(
                                  key: shakeUnitKey,
                                  shakeCount: 3,
                                  shakeOffset: 8,
                                  shakeDuration:
                                      const Duration(milliseconds: 500),
                                  child: InputWidget(
                                      text: 'Unit:',
                                      icon: Icons.scale_rounded,
                                      width: 240,
                                      child: TextInput(
                                          placeholder: "e.g. minutes",
                                          name: 'Unit',
                                          onChanged: (val) {
                                            context
                                                .read<HabitFormCubit>()
                                                .setHabitGoalUnit(val);
                                          }),
                                      onTap: () {}),
                                )
                              : Container(),

                          !widget.recurrent ? Container() : 
                            InputWidget(
                              text: 'Start:',                     //TODO Add text "Start Today"
                              icon: Icons.flag_circle,          //TODO Choose some apropriate icons
                              width: 275,
                                  child: const DateSelect(),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: context
                                          .read<HabitFormCubit>()
                                          .state
                                          .selectedDate!,
                                      firstDate: DateTime(2018),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                onPrimary: Colors
                                                    .black, // selected text color
                                                onSurface: Colors.white,
                                                primary:
                                                    MyColors().primaryColor,
                                                surface:
                                                    MyColors().backgroundColor,
                                              ),
                                              dialogBackgroundColor:
                                                  MyColors().widgetColor,
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  textStyle: TextStyle(
                                                    color:
                                                        MyColors().primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                  foregroundColor: MyColors()
                                                      .primaryColor, // color of button's letters
                                                ),
                                              ),
                                            ),
                                            child: child!);
                                      },
                                    );
                                    if (pickedDate != null) {
                                      context
                                          .read<HabitFormCubit>()
                                          .setHabitDate(pickedDate);
                                    }
                                  }
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
