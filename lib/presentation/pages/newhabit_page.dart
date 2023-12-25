import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/logic/services/notification_service.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../shared/colors.dart';
import '../widgets/recurrence_panel_widgets.dart';
import '../widgets/widgets.dart';

class NewHabitPage extends StatefulWidget {
  final String? habitType;
  final bool trackable;
  final bool recurrent;
  final Habit? habit;
  const NewHabitPage(
      {super.key,
      required this.habitType,
      required this.trackable,
      required this.recurrent,
      this.habit,
      });

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
    bool isEditing = widget.habit != null ? true : false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: NewHabitAppBar(habit: widget.habit),
      bottomNavigationBar: SubmitButton(
          text: 'Save Habit',
          width: MediaQuery.of(context).size.width,
          onPressed: () async {
            final habitFormState = context.read<HabitFormCubit>().state;
            final habitRecurrenceState = context.read<HabitRecurrenceCubit>().state;
            String? time = habitFormState.time != null ? "${habitFormState.time!.hour}:${habitFormState.time!.minute}" : null;
            Map<String, bool?> completionDates = isEditing ? widget.habit!.completionDates : {};
            Map<String, int> measurementValues = isEditing ? widget.habit!.measurementValues : {};
            Map<String, int> scheduleIds = {};

            Habit newHabit({required String habitType, dynamic recurrence, int? goal, String? unit, Map<String, int> scheduleIds = const {}, required bool notify}) {
              if(notify){
                StoredNotifications.saveNotification(habitName: habitFormState.habitName!, schedule: scheduleIds, recurrence: recurrence, time: time!, startDate: habitFormState.selectedDate!); 
              }
              return Habit(
                habitType: habitType, 
                name: habitFormState.habitName!, 
                time: time, 
                notify: habitFormState.notify, 
                date: {
                    "year" :    int.parse(DateFormat('yyyy').format(habitFormState.selectedDate!)), 
                    "month" :   int.parse(DateFormat('M').format(habitFormState.selectedDate!)), 
                    "day" :     int.parse(DateFormat('d').format(habitFormState.selectedDate!)),
                },
                goal: goal,
                unit: unit,
                recurrence: recurrence,
                completionDates: completionDates,
                measurementValues: measurementValues,
              );
            }
            //clear the notifications if they are being edited
            if(isEditing){
              try {
                List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habitFormState.habitName!);
                Map<String, int> decodedSchedule = sharedPreferencesValues[0];
                if(decodedSchedule.isNotEmpty){ 
                  for (int scheduleId in decodedSchedule.values) {
                    AwesomeNotifications().cancel(scheduleId); 
                  }
                }
                await StoredNotifications.removeNotification(habitName: habitFormState.habitName!);
              }
              catch (e){
                //null check operator used on a null value   - if it doesnt exist in SharedPreferences, we dont have to remove it
              }
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
                  isEditing ? boxHabits.put(widget.habit!.key, newHabit(habitType: 'Measurement',recurrence: null, goal: habitFormState.goal, unit: habitFormState.unit, notify: habitFormState.notify)) :
                  boxHabits.add(newHabit(habitType: 'Measurement', recurrence: null, goal: habitFormState.goal, unit: habitFormState.unit, notify: habitFormState.notify));
                  if(context.mounted){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider<HabitHomeCubit>(
                            create: (context) => HabitHomeCubit(),
                          ),
                        ],
                        child: const HomePage(),
                      ))
                    );
                  }
                } else {
                  dynamic recurrence = habitFormState.recurrenceSet;
                  if(habitFormState.recurrenceSet == 'Every Day'){
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: habitFormState.recurrenceSet, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet == 'Custom W.'){
                    recurrence = habitRecurrenceState.weekDays;
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet == 'Custom M.'){
                    recurrence = habitRecurrenceState.monthDays;
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet.contains('Days')) {
                    recurrence = {
                      "interval" : int.parse(habitFormState.recurrenceSet.substring(6,7)),
                      "year" :    int.parse(DateFormat('yyyy').format(DateTime.now())), 
                      "month" :   int.parse(DateFormat('M').format(DateTime.now())), 
                      "day" :     int.parse(DateFormat('d').format(DateTime.now())),
                    };
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  isEditing ? boxHabits.put(widget.habit!.key, newHabit(habitType: 'Measurement', recurrence: recurrence, goal: habitFormState.goal, unit: habitFormState.unit, notify: habitFormState.notify)) :
                  boxHabits.add(newHabit(habitType: 'Measurement', recurrence: recurrence, goal: habitFormState.goal, unit: habitFormState.unit, notify: habitFormState.notify));
                  if(context.mounted){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider<HabitHomeCubit>(
                            create: (context) => HabitHomeCubit(),
                          ),
                        ],
                        child: const HomePage(),
                      ))
                    );
                  }
                }
              }
            }
            if (widget.habitType == 'Yes or No') {
              if (habitFormState.habitName == null ||
                  habitFormState.habitName!.trim().isEmpty) {
                shakeNameKey.currentState?.shake();
              } else {
                if (!widget.recurrent) {
                  if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: null, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                  }
                  isEditing ? boxHabits.put(widget.habit!.key, newHabit(habitType: 'Yes or No', recurrence: null, scheduleIds: scheduleIds, notify: habitFormState.notify)) :
                  boxHabits.add(newHabit(habitType: 'Yes or No', recurrence: null, scheduleIds: scheduleIds, notify: habitFormState.notify));
                  if(context.mounted){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider<HabitHomeCubit>(
                            create: (context) => HabitHomeCubit(),
                          ),
                        ],
                        child: const HomePage(),
                      ))
                    );
                  }
                } else {
                  dynamic recurrence = habitFormState.recurrenceSet;
                  if(habitFormState.recurrenceSet == 'Every Day'){
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: habitFormState.recurrenceSet, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet == 'Custom W.'){
                    recurrence = habitRecurrenceState.weekDays;
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet == 'Custom M.'){
                    recurrence = habitRecurrenceState.monthDays;
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  if(habitFormState.recurrenceSet.contains('Days')) {
                    recurrence = {
                      "interval" : int.parse(habitFormState.recurrenceSet.substring(6,7)),
                    };
                    if(habitFormState.notify == true) {
                      Map<String, int> addScheduleIds = await NotificationService.initalNotificationCreation(recurrence: recurrence, startDate: habitFormState.selectedDate!, habitName: habitFormState.habitName!, time: time!);
                      scheduleIds.addAll(addScheduleIds);
                    }
                  }
                  isEditing ? boxHabits.put(widget.habit!.key, newHabit(habitType: 'Yes or No', recurrence: recurrence, scheduleIds: scheduleIds, notify: habitFormState.notify)) :
                  boxHabits.add(newHabit(habitType: 'Yes or No', recurrence: recurrence, scheduleIds: scheduleIds, notify: habitFormState.notify));
                  if(context.mounted){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider<HabitHomeCubit>(
                            create: (context) => HabitHomeCubit(),
                          ),
                        ],
                        child: const HomePage(),
                      ))
                    );
                    context.read<HabitHomeCubit>().handleSelectedDateChange(context.read<HabitHomeCubit>().state.selectedDate!); //to update the completion bar
                  }
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
                                      initialValue: isEditing ? widget.habit!.name : null,
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
                                      List<String>? timeParts = isEditing ? widget.habit!.time != null ? widget.habit!.time!.split(':') : null : null;
                                      TimeOfDay? newTime = await showTimePicker(
                                        initialEntryMode:
                                            TimePickerEntryMode.dialOnly,
                                        context: context,
                                        initialTime: isEditing ? widget.habit!.time != null ? TimeOfDay(hour: int.parse(timeParts![0]), minute: int.parse(timeParts[1])) : const TimeOfDay(hour: 12, minute: 12) : const TimeOfDay(hour: 12, minute: 12),
                                      );
                                      if (newTime != null) {
                                        if (context.mounted) {
                                          context.read<HabitFormCubit>().setHabitTime(newTime);
                                          context.read<HabitFormCubit>().toggleHabitNotify(true);
                                        }
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
                                      if (context.mounted) {
                                        context.read<HabitFormCubit>().setHabitDate(pickedDate);
                                      }
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
                                          initialValue: isEditing ? '${widget.habit!.goal}' : null,
                                          placeholder: "e.g. 10",
                                          name: 'Goal',
                                          onChanged: (val) {
                                            if (val == '') {
                                            } else {
                                              context
                                                  .read<HabitFormCubit>()
                                                  .setHabitGoal(
                                                      int.parse(val));
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
                                          initialValue: isEditing ? widget.habit!.unit : null,
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
                              icon: Icons.flag_circle,          
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
                                      if (context.mounted) {
                                        context.read<HabitFormCubit>().setHabitDate(pickedDate);
                                      }
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
