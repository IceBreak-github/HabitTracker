import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/presentation/widgets/home_page_widgets.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';
import '../../shared/colors.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<HabitHomeCubit>().handleSelectedDateChange(context.read<HabitHomeCubit>().state.selectedDate!);             //handles the inital habit load
    return Scaffold(
      appBar: const HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          const ProgressBar(),
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 23, top: 60),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior()
                  .copyWith(overscroll: false), //disables scroll glow
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: const Alignment(0.0, 0.42),
                    end: const Alignment(0.0, 1.0),
                    colors: [
                      Colors.transparent,
                      MyColors().backgroundColor.withOpacity(0.9),
                      MyColors().backgroundColor
                    ],
                    //set stops as par your requirement
                    stops: const [0.0, 0.3, 0.97], // 50% transparent, 50% white
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: BlocBuilder<HabitHomeCubit, HabitHomeState>(
                  buildWhen: (previousState, state) {
                    if (previousState.selectedDate != state.selectedDate) {
                      context.read<HabitHomeCubit>().handleSelectedDateChange(state.selectedDate!);
                    }
                    return true;
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: state.shownHabitIndexes.length,
                      itemBuilder: (context, index) {
                        Habit habit = boxHabits.getAt(state.shownHabitIndexes[index]);
                        double height = 51;
                        DateTime? currentDate = state.selectedDate;
                        String formatedCurrentDate = DateFormat('yyyy.MM.d').format(currentDate!);  
                        if (habit.time != null ||
                            habit.habitType == 'Measurement') {
                          height = 107;
                          if (habit.time != null &&
                              habit.habitType == 'Measurement') {
                            height = 145;
                          }
                        }
                        //print("Hive measurementValues: ${habit.measurementValues}");
                        //print("State measurementValues: ${state.measurementValues}");
                        //print("Hive completion dates: ${habit.completionDates}");
                        //print("State isChecked: ${state.isChecked}");
                        return GestureDetector(
                          onTap: () {
                            if(habit.habitType == 'Yes or No'){
                              habit.completionDates[formatedCurrentDate] = !context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_${habit.name}"]!;
                              boxHabits.putAt(state.shownHabitIndexes[index], habit);
                              context.read<HabitHomeCubit>().setCheckValue("${formatedCurrentDate}_${habit.name}",!context.read<HabitHomeCubit>().state.isChecked["${formatedCurrentDate}_${habit.name}"]!);               //because we cant devide with zero
                              context.read<HabitHomeCubit>().updateProgressBar();
                            }
                            if(habit.habitType == 'Measurement'){
                              showChangeMeasurementValuePopUp(context: context, habit: habit, index: state.shownHabitIndexes[index], formatedCurrentDate: formatedCurrentDate);
                            }
                          },
                          onLongPressStart: (details) {
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => const HabitPage()));            //TODO: its too hard to click the checkbox without triggering this, fix 
                            showEditHabitPopUp(context: context, habit: habit);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyColors().widgetColor,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.10),
                                    blurRadius:
                                        4.0, // soften the shadow
                                    spreadRadius:
                                        4.0, //extend the shadow
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
                                              ? HabitCheckBox(
                                                  habitName: habit.name,
                                                  formatedCurrentDate:
                                                      formatedCurrentDate,
                                                  habit: habit,
                                                  index: state.shownHabitIndexes[index])
                                              : HabitMeasurementBox(
                                                  habit: habit,
                                                  index: state.shownHabitIndexes[index],
                                                  formatedCurrentDate:
                                                      formatedCurrentDate)
                                      ),
                                    ],
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
                              ),
                            ),
                          ),
                        );
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
                String formatedCurrentDate =
                DateFormat('yyyy.MM.d').format(currentDate!);
                context.read<HabitHomeCubit>().cleanHomeCubit(formatedCurrentDate); //clears the Cubit
                context.read<HabitHomeCubit>().selectDate(value); //changes the selectedDate
              },
            ),
          ),
          Positioned(
              bottom: 110,
              left: 20,
              child: TextButton.icon(
                  icon: const Icon(Icons.query_stats),
                  label: const Text('Statistics'),
                  onPressed: () {
                    //boxHabits.clear();
                  })),
        ],
      ),
      floatingActionButton: const AddHabitButton(),
      drawer: const Drawer(),
    );
  }
}
