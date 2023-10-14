import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
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
            //print('HabitType: ${widget.habitType}');
            //print('Trackable: ${widget.trackable}');
            //print('Recurrent: ${widget.recurrent}');

            //print('Habitname = ${habitName}');
            //print('Time = ${time}');
            //print('Notify = ${notify}');
            /*
                if(recurrenceSet == 'Custom W.'){
                  //print(weekDays);
                }
                if(recurrenceSet == 'Custom M.'){
                  //print(monthDays);
                }
                else {
                  //print(recurrenceSet);
                }
                */
            final habitFormState = context.read<HabitFormCubit>().state;
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
                  //print(habitFormState.habitName);
                  //print(habitFormState.time);
                  //print(habitFormState.notify);
                  //print(habitFormState.selectedDate);
                  //print(habitFormState.goal);
                  //print(habitFormState.unit);
                } else {
                  //print(habitFormState.habitName);
                  //print(habitFormState.time);
                  //print(habitFormState.notify);

                  //print(habitFormState.goal);
                  //print(habitFormState.unit);
                  //print(habitFormState.recurrenceSet);
                }
              }
            }
            if (widget.habitType == 'Yes or No') {
              if (habitFormState.habitName == null ||
                  habitFormState.habitName!.trim().isEmpty) {
                shakeNameKey.currentState?.shake();
              } else {
                if (!widget.recurrent) {
                  //print(habitFormState.habitName);
                  //print(habitFormState.time);
                  //print(habitFormState.notify);
                  //print(habitFormState.selectedDate);
                } else {
                  //print(habitFormState.habitName);
                  //print(habitFormState.time);
                  //print(habitFormState.notify);
                  //print(habitFormState.recurrenceSet);
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
