import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/logic/services/notification_service.dart';
import 'package:habit_tracker/presentation/pages/newhabit_page.dart';
import 'package:habit_tracker/presentation/widgets/button_widgets.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:habit_tracker/shared/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../shared/boxes.dart';

List computeRecurrencePanel({required Habit habit}) {
  if (habit.recurrence is String && habit.recurrence == 'Every Day') {
    return ['Every Day', {'interval': true, 'week': false, 'month' : false}];
  }
  if (habit.recurrence is Map) {
    if (habit.recurrence.containsKey("interval")) {
      return ['Every ${habit.recurrence['interval']} Days', {'interval': true, 'week': false, 'month' : false}];
    } else if (habit.recurrence.containsKey('Monday')) {
      return ['Custom W.', {'interval': false, 'week': true, 'month' : false}];
    } else if (habit.recurrence.keys.every((key) => key is int)) {
      return ['Custom M.', {'interval': false, 'week': false, 'month' : true}];
    }
  }
  return [];
}

showChangeMeasurementValuePopUp({required BuildContext context, required Habit habit, required int index, required String formatedCurrentDate}){
  String textValue = '0';
  final controller = TextEditingController();
    controller.text = textValue;
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textValue.length,
  );
  showDialog(
    barrierDismissible:
        true,
    context:
        context,
    builder:
        (context) {
      return AlertDialog(
        title:
            const Text(
          "Note",
          textAlign:
              TextAlign.center,
          style: TextStyle(
              fontSize:
                  17,
              color:
                  Colors.white,
              fontWeight: FontWeight.w500),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(20.0))),
        backgroundColor:
            MyColors()
                .widgetColor,
        titlePadding:
            const EdgeInsets.only(
                top: 27),
        insetPadding:
            EdgeInsets
                .zero,
        contentPadding:
            const EdgeInsets.only(
                top: 10),
        clipBehavior:
            Clip.antiAliasWithSaveLayer,
        content:
            SizedBox(
          height:
              90,
          width:
              110,
          child:
              Builder(
            builder:
                (context) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 36,
                      width: 85,
                      decoration: BoxDecoration(color: MyColors().backgroundColor, borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: TextFormField(
                          controller: controller,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: MyColors().secondaryColor,
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value == '') {
                              context.read<HabitHomeCubit>().changeMeasurementValue(0);
                            } else {
                              habit.measurementValues[formatedCurrentDate] = int.parse(value);
                              boxHabits.put(habit.key, habit);
                              context.read<HabitHomeCubit>().changeMeasurementValue(int.parse(value));
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 35),
                    SizedBox(
                      height: 36,
                      width: 75,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors().primaryColor.withOpacity(0.1),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            int value = context.read<HabitHomeCubit>().state.measureNumber;
                            context.read<HabitHomeCubit>().setMeasurementValues("${formatedCurrentDate}_${habit.name}", value);
                            List<String> dateParts = formatedCurrentDate.split('.');
                            DateTime currentDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
                            String nowDate = DateFormat('yyyy.M.d').format(DateTime.now());
                            if (value >= habit.goal!){
                                habit.completionDates.addAll({formatedCurrentDate : null});
                                boxHabits.put(index, habit);
                                context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_${habit.name}", true);
                                if(habit.notify == true && DateTime(currentDate.year, currentDate.month, currentDate.day).isAtSameMomentAs(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))){
                                  List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habit.name);
                                  Map<String, int> decodedSchedule = sharedPreferencesValues[0];
                                  if(decodedSchedule.containsKey(nowDate)){
                                    AwesomeNotifications().cancel(decodedSchedule[nowDate]!);
                                  }    
                                }
                            }
                            else {
                              habit.completionDates.remove(formatedCurrentDate);
                              boxHabits.put(index, habit);
                              context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_${habit.name}", false);
                              if(habit.notify == true && DateTime(currentDate.year, currentDate.month, currentDate.day).isAtSameMomentAs(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))){
                                List<String> timeParts = habit.time!.split(':');
                                List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habit.name);
                                Map<String, int> decodedSchedule = sharedPreferencesValues[0];
                                if(decodedSchedule.containsKey(nowDate)){
                                  NotificationService.createCalendarNotification(
                                    id: decodedSchedule[nowDate]!,
                                    hour: int.parse(timeParts[0]),
                                    minute: int.parse(timeParts[1]),
                                    day: DateTime.now().day,
                                    month: DateTime.now().month,
                                    year: DateTime.now().year,
                                    title: habit.name,
                                    body: "Don't forget to complete your Habit !",
                                  ); 
                                }
                              }
                            }
                            if(context.mounted){
                              context.read<HabitHomeCubit>().updateProgressBar();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Save', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
}

showEditHabitPopUp({required BuildContext context, required Habit habit}){                 //TODO style it better
showDialog(
    barrierDismissible:
        true,
    context:
        context,
    builder:
        (context) {
      return AlertDialog(
        title:
            Text(
          habit.name,
          textAlign:
              TextAlign.center,
          style: const TextStyle(
              fontSize:
                  17,
              color:
                  Colors.white,
              fontWeight: FontWeight.w500),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(20.0))),
        backgroundColor:
            MyColors()
                .widgetColor,
        titlePadding:
            const EdgeInsets.only(
                top: 27),
        insetPadding:
            EdgeInsets
                .zero,
        contentPadding:
            const EdgeInsets.only(
                top: 30),
        clipBehavior:
            Clip.antiAliasWithSaveLayer,
        content:
            SizedBox(
          height:
              127,
          width:
              160,
          child:
              Builder(
            builder:
                (context) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            onTap: () {
                                  List<String>? timeParts = habit.time != null ? habit.time!.split(':') : null;
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<HabitFormCubit>(
                                          create: (context) => HabitFormCubit(
                                            habitName: habit.name, 
                                            time: timeParts != null ? TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])) : null,
                                            notify: habit.notify,
                                            recurrenceSet: habit.recurrence != null ? computeRecurrencePanel(habit: habit)[0] : null,          
                                            goal: habit.goal,
                                            unit: habit.unit,
                                            selectedDate: DateTime(habit.date['year'], habit.date['month'], habit.date['day']),           
                                          ),
                                        ),
                                        BlocProvider<HabitRecurrenceCubit>(
                                          create: (context) => HabitRecurrenceCubit(
                                            recurrenceValue: habit.recurrence is String || habit.recurrence.containsKey("interval") ? computeRecurrencePanel(habit: habit)[0] : null,
                                            weekDays: habit.recurrence is Map && habit.recurrence.containsKey('Monday') ? (habit.recurrence as Map?)?.cast<String, bool>() : null,      //Checks if habit.recurrence <Dynamic, Dyanmic> is for weekDays
                                            monthDays: habit.recurrence is Map &&  habit.recurrence.keys.every((key) => key is int) ? (habit.recurrence as Map?)?.cast<int, bool>() : null,
                                            pages: computeRecurrencePanel(habit: habit)[1]
                                          ),
                                        ),
                                      ],
                                      child: NewHabitPage(
                                        habitType: habit.habitType,
                                        trackable: true,
                                        recurrent: habit.recurrence == null ? false : true,
                                        habit: habit,
                                      ),
                                    )
                                  )
                                 );
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.drive_file_rename_outline_rounded, color: MyColors().primaryColor, size: 18),
                                const SizedBox(width: 20),
                                Text('Edit', style: TextStyle(color: MyColors().primaryColor, fontSize: 14)),
                              ],
                            ),
                            tileColor: MyColors().primaryColor.withOpacity(0.1) 
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            //tileColor: Colors.white,
                            title: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Reset Progress', style: TextStyle(color: MyColors().lightGrey, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: SizedBox(
        height: 45,
        child: BlocBuilder<HabitHomeCubit, HabitHomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleAnimationProgressBar(
                  height: 10,
                  width: 233,
                  backgroundColor: MyColors().widgetColor,
                  foregrondColor: MyColors().primaryColor,
                  ratio: state.progressBar['ratio'],
                  direction: Axis.horizontal,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(seconds: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text('${state.progressBar['countTrueValues']}'                     //TODO: set the width, so it doesnt change the lenght of the text when changing states
                              ,
                          style: TextStyle(
                              color: MyColors().primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Text(' out of ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12)),
                      Text(
                         
                             '${state.progressBar['allHabits']}'
                              ,
                          style: TextStyle(
                              color: MyColors().primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Text(' completed ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HabitCheckBox extends StatelessWidget {
  final String habitName;
  final String formatedCurrentDate;
  final Habit habit;
  final int index;
  final DateTime currentDate;
  const HabitCheckBox({super.key, required this.habitName, required this.formatedCurrentDate, required this.habit, required this.index, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 21,
      height: 21,
      child: CustomCheckbox(
        name: habitName,
        date: formatedCurrentDate,
        onChanged: () {
          if(currentDate.isAfter(DateTime.now())){
            //do nothing
          }
          else {
            if(habit.completionDates.containsKey(formatedCurrentDate)){
              habit.completionDates.remove(formatedCurrentDate);
            }
            else {
              habit.completionDates.addAll({formatedCurrentDate: null});
            }
            boxHabits.put(habit.key, habit);
            context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_$habitName",!context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_$habitName"]!);               //because we cant devide with zero
            context.read<HabitHomeCubit>().updateProgressBar();
          }
        }
      ),
    );
  }
}

class HabitMeasurementBox extends StatelessWidget {
  final Habit habit;
  final int index;
  final String formatedCurrentDate;
  final DateTime currentDate;
  const HabitMeasurementBox({super.key, required this.habit, required this.index, required this.formatedCurrentDate, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: RawMaterialButton(
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
        onPressed: () {
          if(currentDate.isAfter(DateTime.now())){

          }
          else {
            showChangeMeasurementValuePopUp(context: context, habit: habit, index: index, formatedCurrentDate: formatedCurrentDate);
          }
        },
        constraints: const BoxConstraints(),
        fillColor: MyColors().backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius
                      .circular(
                          5)),
        elevation: 0,
        child: BlocBuilder<HabitHomeCubit, HabitHomeState>(
          builder: (context, state) {
            int? result = state.measurementValues["${formatedCurrentDate}_${habit.name}"] ?? habit.measurementValues[formatedCurrentDate] ?? 0;
            bool done = false;
            
            if(state.isChecked["${formatedCurrentDate}_${habit.name}"] == true){                       //TODO when the user edits the habit goal it remains checked even when it shouldnt
              done = true;
            }
            return Text(
                "$result",
                style: TextStyle(
                    color: done ? MyColors().primaryColor : MyColors().lightGrey,
                    fontWeight:
                        FontWeight
                            .w600,
                    fontSize:
                        12));
          },
        ),
      ));
  }
}

class AddHabitButton extends StatelessWidget {
  const AddHabitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 9, bottom: 90),
      child: SizedBox(
          height: 60, //50
          width: 60, //50
          child: FloatingActionButton(
            onPressed: () {
              createHabitPopUp(context);
            },
            //elevation: 0,
            backgroundColor: MyColors().primaryColor,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.black,
              size: 50, //40
            ),
          )),
    );
  }
}

class SingleHabit extends StatelessWidget {
  final double height;
  final Habit habit;
  final String formatedCurrentDate;
  final int index;
  final DateTime currentDate;
  const SingleHabit({super.key, required this.height, required this.habit, required this.formatedCurrentDate, required this.index, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: height == 107 || height == 145
              ? 24
              : 15),
      child: Column(children: [
        SizedBox(
          height: habit.habitType == 'Yes or No' ? 21 : 24,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10),
                child: Text(
                  habit.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                  padding:const EdgeInsets.only(right: 10, left: 20),
                  child: (habit.habitType ==
                          'Yes or No')
                      ? currentDate.isAfter(DateTime.now()) ? Icon(Icons.lock_clock_outlined, size: 18, color: MyColors().lightGrey) : HabitCheckBox(
                          habitName: habit.name,
                          formatedCurrentDate:
                              formatedCurrentDate,
                          habit: habit,
                          index: index,
                          currentDate: currentDate
                          )
                      : currentDate.isAfter(DateTime.now()) ? Icon(Icons.lock_clock_outlined, size: 18, color: MyColors().lightGrey) : HabitMeasurementBox(
                          habit: habit,
                          index: index,
                          formatedCurrentDate:formatedCurrentDate,
                          currentDate: currentDate
                          )
              ),
            ],
          ),
        ),
        (habit.time != null)
            ? Padding(
                padding:
                    const EdgeInsets.only(
                        top: 18,
                        left: 10,
                        right: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                      color: MyColors()
                          .secondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text('Time:',
                        style: TextStyle(
                            color: MyColors()
                                .lightGrey,
                            fontSize: 12)),
                    const SizedBox(width: 10),
                    Text(habit.time!,
                        style: TextStyle(
                            color: MyColors()
                                .primaryColor,
                            fontSize: 12)),
                  ],
                ),
              )
            : Container(),
        (habit.goal != null)
            ? Padding(
                padding:
                    const EdgeInsets.only(
                        top: 18,
                        left: 10,
                        right: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.stars,
                      color: MyColors()
                          .secondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text('Goal:',
                        style: TextStyle(
                            color: MyColors()
                                .lightGrey,
                            fontSize: 12)),
                    const SizedBox(width: 10),
                    Text(
                        "${habit.goal}  ${habit.unit}",
                        style: TextStyle(
                            color: MyColors()
                                .primaryColor,
                            fontSize: 12)),
                  ],
                ),
              )
            : Container(),
      ]),
    );
  }
}



