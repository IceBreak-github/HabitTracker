import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';

import '../../logic/cubits/date_select_cubit_cubit.dart';
import '../../shared/colors.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: <Widget>[
          //TODO: add progress bar
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 23),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior()
                  .copyWith(overscroll: false), //disables scroll glow
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: const Alignment(0.0, 0.53),
                    end: const Alignment(0.0, 1.0),
                    colors: [
                      Colors.transparent,
                      MyColors().backgroundColor.withOpacity(0.9),
                      MyColors().backgroundColor
                    ],
                    //set stops as par your requirement
                    stops: const [0.0, 0.5, 0.9], // 50% transparent, 50% white
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 160),
                  itemCount: boxHabits.length,
                  itemBuilder: (context, index) {
                    Habit habit = boxHabits.getAt(index);
                    double height = 51;
                    if (habit.time != null ||
                        habit.habitType == 'Measurement') {
                      height = 107;
                      if (habit.time != null &&
                          habit.habitType == 'Measurement') {
                        height = 145;
                      }
                    }
                    return BlocBuilder<DateSelectCubit, DateSelectState>(
                      builder: (context, state) {
                        bool show = false;
                        final dateSelectedState =
                            context.read<DateSelectCubit>().state;
                        DateTime? currentDate = dateSelectedState.selectedDate;
                        if (habit.recurrence == null){
                          if("${habit.date['year']}.${habit.date['month']}.${habit.date['day']}" == DateFormat('yyyy.MM.d').format(currentDate!)){
                            show = true;
                          }
                        }
                        else {
                          if(DateTime(habit.date['year'], habit.date['month'], habit.date['day']).isBefore(currentDate!)){
                              if (habit.recurrence is String && habit.recurrence == 'Every Day') {
                                show = true;
                              }
                              if (habit.recurrence is Map &&
                                  habit.recurrence.containsKey(
                                      int.parse(DateFormat('d').format(currentDate)))) {
                                show = true;
                              }
                              if (habit.recurrence is Map && habit.recurrence.containsKey(DateFormat('EEEE').format(currentDate)) && habit.recurrence[DateFormat('EEEE').format(currentDate)]){
                                show = true;
                              }
                              if (habit.recurrence is Map && habit.recurrence.containsKey("interval")) {
                                  DateTime startDate = DateTime(habit.recurrence["year"], habit.recurrence['month'], habit.recurrence['day']); // Replace with your starting date
                                  Duration interval = Duration(days: habit.recurrence["interval"]);
                                  // Calculate the difference in days between the current date and the starting date
                                  int daysDifference = currentDate.difference(startDate).inDays;
                
                                  // Check if the current date is every third day from the starting date
                                  bool isEveryXDay = daysDifference % interval.inDays == 0;
                
                                  if (isEveryXDay) {
                                    show = true;
                                  } else {
                                    show = false;
                                  }
                              }
                          }
                          else {
                            show = false;
                          }
                        
                        }
                
                        return show ? Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColors().widgetColor,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 4.0, // soften the shadow
                                  spreadRadius: 4.0, //extend the shadow
                                  offset: const Offset(
                                    2.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                  ),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top:
                                      height == 107 || height == 145 ? 24 : 15),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
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
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 20),
                                        child: (habit.habitType == 'Yes or No')
                                            ? SizedBox(
                                                width: 21,
                                                height: 21,
                                                child: ElevatedButton(
                                                  onPressed:
                                                      () {}, //TODO: create habit completion
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: Size.zero,
                                                    backgroundColor: MyColors()
                                                        .backgroundColor,
                                                    elevation: 0,
                                                    shape: const CircleBorder(),
                                                  ),
                                                  child: null,
                                                ))
                                            : SizedBox(
                                                width: 40,
                                                height: 26,
                                                child: ElevatedButton(
                                                  onPressed:
                                                      () {}, 
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: Size.zero,
                                                    backgroundColor: MyColors()
                                                        .backgroundColor,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                  ),
                                                  child: Text('0',
                                                      style: TextStyle(
                                                          color: MyColors()
                                                              .lightGrey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ))),
                                  ],
                                ),
                                (habit.time != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18, left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later,
                                              color: MyColors().secondaryColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            Text('Time:',
                                                style: TextStyle(
                                                    color: MyColors().lightGrey,
                                                    fontSize: 12)),
                                            const SizedBox(width: 10),
                                            Text(habit.time!,
                                                style: TextStyle(
                                                    color:
                                                        MyColors().primaryColor,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (habit.goal != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18, left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.stars,
                                              color: MyColors().secondaryColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            Text('Goal:',
                                                style: TextStyle(
                                                    color: MyColors().lightGrey,
                                                    fontSize: 12)),
                                            const SizedBox(width: 10),
                                            Text("${habit.goal}  ${habit.unit}",
                                                style: TextStyle(
                                                    color:
                                                        MyColors().primaryColor,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ]),
                            ),
                          ),
                        ) : Container();
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            child: DateTimeLine(
              width: MediaQuery.of(context).size.width,
              color: MyColors().primaryColor,
              hintText: "",
              onSelected: (value) {
                context.read<DateSelectCubit>().selectDate(value);
              },
            ),
          ),
          /*
          Positioned(
              bottom: 110,
              left: 20,
              child: TextButton.icon(
                  //TODO: Remove later, this is here only for testing
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete all'),
                  onPressed: () {
                    boxHabits.clear();
                  })), */
        ],
      ),
      floatingActionButton: Padding(
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
      ),
      drawer: const Drawer(),
    );
  }
}
