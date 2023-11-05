import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/presentation/widgets/button_widgets.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../shared/boxes.dart';

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
                            int value = context.read<HabitHomeCubit>().state.measureNumber;
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
                            context.read<HabitHomeCubit>().updateProgressBar();

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
                      Text( '${state.progressBar['countTrueValues']}'
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
  const HabitCheckBox({super.key, required this.habitName, required this.formatedCurrentDate, required this.habit, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 21,
      height: 21,
      child: CustomCheckbox(
        name: habitName,
        date: formatedCurrentDate,
        onChanged: () {
          habit.completionDates[formatedCurrentDate] = !context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_$habitName"]!;
          boxHabits.putAt(index, habit);
          context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_$habitName",!context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_$habitName"]!);               //because we cant devide with zero
          context.read<HabitHomeCubit>().updateProgressBar();
        },
      ),
    );
  }
}

class HabitMeasurementBox extends StatelessWidget {
  final Habit habit;
  final int index;
  final String formatedCurrentDate;
  const HabitMeasurementBox({super.key, required this.habit, required this.index, required this.formatedCurrentDate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: RawMaterialButton(
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
        onPressed: () {
          showChangeMeasurementValuePopUp(context: context, habit: habit, index: index, formatedCurrentDate: formatedCurrentDate);
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

