import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';
import '../../shared/colors.dart';
import '../widgets/button_widgets.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/widgets.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

//TODO: when the user goes back to the home page the DateTime widget gets messed up

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String textValue = '0';
    final controller = TextEditingController();
    controller.text = textValue;
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textValue.length,
    );

    return Scaffold(
      appBar: const HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: SizedBox(
              height: 45,
              child: BlocBuilder<HabitHomeCubit, HabitHomeState>(
                //TODO: do something with the flickering when state changes
                builder: (context, state) {
                  if (state.isChecked.isNotEmpty) {
                    int allHabits = state.isChecked.length;
                    int countTrueValues = state.isChecked.values
                        .where((value) => value == true)
                        .length;
                    double ratio = countTrueValues / allHabits;
                    context
                        .read<HabitHomeCubit>()
                        .updateValues(allHabits, countTrueValues, ratio);
                    context.read<HabitHomeCubit>().setHasAnyHabits(true);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleAnimationProgressBar(
                        height: 10,
                        width: 233,
                        backgroundColor: MyColors().widgetColor,
                        foregrondColor: MyColors().primaryColor,
                        ratio:
                            state.hasAnyHabits ? state.progressBar['ratio'] : 0,
                        direction: Axis.horizontal,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Text(
                                state.hasAnyHabits
                                    ? '${state.progressBar['countTrueValues']}'
                                    : '0',
                                style: TextStyle(
                                    color: MyColors().primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            const Text(' out of ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            Text(
                                state.hasAnyHabits
                                    ? '${state.progressBar['allHabits']}'
                                    : '0',
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 23, top: 60),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior()
                  .copyWith(overscroll: false), //disables scroll glow
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: const Alignment(0.0, 0.59),
                    end: const Alignment(0.0, 1.0),
                    colors: [
                      Colors.transparent,
                      MyColors().backgroundColor.withOpacity(0.9),
                      MyColors().backgroundColor
                    ],
                    //set stops as par your requirement
                    stops: const [0.0, 0.4, 0.95], // 50% transparent, 50% white
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
                    return BlocBuilder<HabitHomeCubit, HabitHomeState>(
                      builder: (context, state) {
                        bool show = false;
                        DateTime? currentDate =
                            context.read<HabitHomeCubit>().state.selectedDate;
                        String formatedCurrentDate =
                            DateFormat('yyyy.MM.d').format(currentDate!);

                        //Logic to determine wether to show the habit of not, based on recurrence
                        if (habit.recurrence == null) {
                          if ("${habit.date['year']}.${habit.date['month']}.${habit.date['day']}" ==
                              DateFormat('yyyy.MM.d').format(currentDate)) {
                            show = true;
                          }
                        } else {
                          if (DateTime(habit.date['year'], habit.date['month'],
                                  habit.date['day'])
                              .isBefore(currentDate)) {
                            if (habit.recurrence is String &&
                                habit.recurrence == 'Every Day') {
                              show = true;
                            }
                            if (habit.recurrence is Map &&
                                habit.recurrence.containsKey(int.parse(
                                    DateFormat('d').format(currentDate)))) {
                              show = true;
                            }
                            if (habit.recurrence is Map &&
                                habit.recurrence.containsKey(
                                    DateFormat('EEEE').format(currentDate)) &&
                                habit.recurrence[
                                    DateFormat('EEEE').format(currentDate)]) {
                              show = true;
                            }
                            if (habit.recurrence is Map &&
                                habit.recurrence.containsKey("interval")) {
                              DateTime startDate = DateTime(
                                  habit.recurrence["year"],
                                  habit.recurrence['month'],
                                  habit.recurrence[
                                      'day']); // Replace with your starting date
                              Duration interval =
                                  Duration(days: habit.recurrence["interval"]);
                              // Calculate the difference in days between the current date and the starting date
                              int daysDifference =
                                  currentDate.difference(startDate).inDays;

                              // Check if the current date is every X day from the starting date
                              bool isEveryXDay =
                                  daysDifference % interval.inDays == 0;

                              if (isEveryXDay) {
                                show = true;
                              }
                            }
                          }
                        }
                        // Logic to determine if the habit has been checked

                        if (habit.completionDates
                                .containsKey(formatedCurrentDate) &&
                            show == true) {
                          context.read<HabitHomeCubit>().setCheckValue(
                              "${formatedCurrentDate}_${habit.name}",
                              habit.completionDates[
                                  formatedCurrentDate]!); // updates UI
                        }
                        if (!habit.completionDates
                                .containsKey(formatedCurrentDate) &&
                            show == true) {
                          context.read<HabitHomeCubit>().setCheckValue(
                              "${formatedCurrentDate}_${habit.name}",
                              false); //TODO: if two habits have the same name, bad stuff will happen
                        }
                        if (context
                            .read<HabitHomeCubit>()
                            .state
                            .isChecked
                            .isEmpty) {
                          //This is how I am dealing with the flickering now, maybe change
                          context.read<HabitHomeCubit>().setHasAnyHabits(false);
                        }
                        /*
                        print("Hive measurementValues: ${habit.measurementValues}");
                        print("State measurementValues: ${state.measurementValues}");
                        print("Hive completion dates: ${habit.completionDates}");
                        print("State isChecked: ${state.isChecked}");
                        */

                        return show
                            ? Padding(
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
                                        top: height == 107 || height == 145
                                            ? 24
                                            : 15),
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
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
                                              child:
                                                  (habit.habitType ==
                                                          'Yes or No')
                                                      ? SizedBox(
                                                          width: 21,
                                                          height: 21,
                                                          child: CustomCheckbox(
                                                            name: habit.name,
                                                            date: DateFormat(
                                                                    'yyyy.MM.d')
                                                                .format(
                                                                    currentDate),
                                                            onChanged: () {
                                                              habit.completionDates[formatedCurrentDate] = !context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_${habit.name}"]!;
                                                              boxHabits.putAt(index, habit);
                                                              context
                                                                  .read<
                                                                      HabitHomeCubit>()
                                                                  .setCheckValue(
                                                                      "${formatedCurrentDate}_${habit.name}",
                                                                      !context
                                                                          .read<
                                                                              HabitHomeCubit>()
                                                                          .state
                                                                          .isChecked["${formatedCurrentDate}_${habit.name}"]!);
                                                            },
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          
                                                          height: 26,
                                                          child: RawMaterialButton(
                                                            padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                                                            onPressed: () {
                                                              showDialog(
                                                                  //TODO:  make it work, style it better, make the intial text selected when open
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
                                                                                            boxHabits.putAt(index, habit);
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
                                                                                        onPressed: () {
                                                                                          //TODO create the logic, create the state variables, create Hive field
                                                                                          int value = context.read<HabitHomeCubit>().state.measurementValue;
                                                                                          context.read<HabitHomeCubit>().setMeasurementValues("${formatedCurrentDate}_${habit.name}", value);
                                                                                          if (value >= habit.goal!){
                                                                                              habit.completionDates[formatedCurrentDate] = true;
                                                                                              boxHabits.putAt(index, habit);
                                                                                              context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_${habit.name}", true);
                                                                                          }
                                                                                          else {
                                                                                              habit.completionDates[formatedCurrentDate] = false;
                                                                                              boxHabits.putAt(index, habit);
                                                                                              context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_${habit.name}", false);
                                                                                          }

                                                                                          Navigator.pop(context);
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
                                                            },
                                                            constraints: BoxConstraints(),
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
                                                                
                                                                if(state.isChecked["${formatedCurrentDate}_${habit.name}"] == true){
                                                                  done = true;
                                                                }
                                                                
                                                                return Text(
                                                                    "$result", //TODO change here
                                                                    style: TextStyle(
                                                                        color: done ? MyColors().primaryColor : MyColors().lightGrey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            12));
                                                              },
                                                            ),
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
                                              padding: const EdgeInsets.only(
                                                  top: 18, left: 10, right: 10),
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
                                  ),
                                ),
                              )
                            : Container();
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
                DateTime? currentDate =
                    context.read<HabitHomeCubit>().state.selectedDate;
                String formatedCurrentDate = DateFormat('yyyy.MM.d').format(currentDate!);
                context.read<HabitHomeCubit>().removeCheckValue(formatedCurrentDate); //remove all keys which start with the current date from the state, since we dont need them
                context.read<HabitHomeCubit>().removeMeasurementValues(formatedCurrentDate);   //clears the cubit state

                context.read<HabitHomeCubit>().selectDate(value);        //changes the selectedDate
              },
            ),
          ),
          Positioned(
              bottom: 110,
              left: 20,
              child: TextButton.icon(
                  //TODO: Remove later, this is here only for testing
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete all'),
                  onPressed: () {
                    boxHabits.clear();
                  })),
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
