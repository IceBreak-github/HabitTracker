import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/shared/colors.dart';

import 'button_widgets.dart';

recurrencePanel(BuildContext context) {
      final HabitRecurrenceCubit habitRecurrenceCubit = context.read<HabitRecurrenceCubit>();
      // Save the current state to a variable before showing the bottom sheet
      String savedRecurrence = habitRecurrenceCubit.state.recurrenceValue;
      Map<String, bool> savedLastPage = Map.from(habitRecurrenceCubit.state.pages);
      Map<int, bool> savedMonthDays = Map.from(habitRecurrenceCubit.state.monthDays);
      Map<String, bool> savedWeekDays = Map.from(habitRecurrenceCubit.state.weekDays);

      return showModalBottomSheet<bool>(
          //enableDrag: false,
          isScrollControlled: true,
          //isDismissible: false,
          context: context,
          backgroundColor: MyColors().widgetColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          builder: (BuildContext innercontext) {
            var recurrencePanel = Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Container(
                        height: 5,
                        width: 85,
                        decoration: const ShapeDecoration(
                          color: Color.fromRGBO(55, 55, 82, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Set Recurrence',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, bottom: 12, left: 20),
                      child: SizedBox(
                        height: 36,
                        width: 83,
                        child: BlocBuilder<HabitRecurrenceCubit,
                            HabitRecurrenceState>(
                          builder: (context, state) {
                            bool interval = state
                                .pages['interval']!;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(                 
                                backgroundColor: interval
                                    ? MyColors().secondaryColor
                                    : MyColors().backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                context
                                    .read<HabitRecurrenceCubit>()
                                    .selectPage('interval');
                              },
                              child: Text('Interval',
                                  style: TextStyle(
                                      color: interval
                                          ? Colors.black
                                          : MyColors().lightGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: SizedBox(
                        height: 36,
                        width: 83,
                        child: BlocBuilder<HabitRecurrenceCubit,
                            HabitRecurrenceState>(
                          builder: (context, state) {
                            bool week = state
                                .pages['week']!;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: week
                                    ? MyColors().secondaryColor
                                    : MyColors().backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                context
                                    .read<HabitRecurrenceCubit>()
                                    .selectPage('week');
                              },
                              child: Text('Week',
                                  style: TextStyle(
                                      color: week
                                          ? Colors.black
                                          : MyColors().lightGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, bottom: 12, right: 20),
                      child: SizedBox(
                        height: 36,
                        width: 83,
                        child: BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
                          builder: (context, state) {
                            bool month = state.pages['month']!;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: month
                                    ? MyColors().secondaryColor
                                    : MyColors().backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                    context
                                    .read<HabitRecurrenceCubit>()
                                    .selectPage('month');
                              },
                              child: Text('Month',
                                  style: TextStyle(
                                      color: month
                                          ? Colors.black
                                          : MyColors().lightGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child:
                      Divider(height: 1, color: Color.fromRGBO(82, 82, 82, 1)),
                ),
                BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
                  builder: (context, state) {
                    bool interval = state.pages['interval']!;
                    return interval ? const IntervalPage() : Container();
                  },
                ),
                BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
                  builder: (context, state) {
                    bool week = state.pages['week']!;
                    return week ? const WeekPage() : Container();
                  },
                ),
                BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
                  builder: (context, state) {
                    bool month = state.pages['month']!;
                    return month ? const MonthPage() : Container();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 30),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      SaveRecurrenceButton(onTap: (){
                          if (context.read<HabitRecurrenceCubit>().state.pages['interval']!) {
                            String value = context.read<HabitRecurrenceCubit>().state.recurrenceValue;
                            HabitRecurrenceCubit defaultRecurrenceValues = HabitRecurrenceCubit();
                            context.read<HabitFormCubit>().setHabitRecurrence(value);
                            habitRecurrenceCubit.setWeekDays(defaultRecurrenceValues.state.weekDays);
                            habitRecurrenceCubit.setMonthDays(defaultRecurrenceValues.state.monthDays);
                          }
                          if (context.read<HabitRecurrenceCubit>().state.pages['week']!) {
                            context.read<HabitFormCubit>().setHabitRecurrence('Custom W.');
                            HabitRecurrenceCubit defaultRecurrenceValues = HabitRecurrenceCubit();
                            habitRecurrenceCubit.setMonthDays(defaultRecurrenceValues.state.monthDays);
                            habitRecurrenceCubit.setRecurrenceValue(defaultRecurrenceValues.state.recurrenceValue);
                          }
                          if (context.read<HabitRecurrenceCubit>().state.pages['month']!) {
                            context.read<HabitFormCubit>().setHabitRecurrence('Custom M.');
                            HabitRecurrenceCubit defaultRecurrenceValues = HabitRecurrenceCubit();
                            habitRecurrenceCubit.setWeekDays(defaultRecurrenceValues.state.weekDays);
                            habitRecurrenceCubit.setRecurrenceValue(defaultRecurrenceValues.state.recurrenceValue);
                          }
                          Navigator.of(context).pop(true);
                      })
                  ]),
                ),
              ],
            );
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<HabitFormCubit>(),
                ),
                BlocProvider.value(
                  value: context.read<HabitRecurrenceCubit>(),
                ),
              ],
              child: recurrencePanel,
            );
          }
        ).then(
          (isManuallyHidden) {
            if (isManuallyHidden ?? false) {        //hidden via button
              //keep the state
            } else {                              //dismissed
              //revert to the previous state
              habitRecurrenceCubit.setRecurrenceValue(savedRecurrence);
              habitRecurrenceCubit.setWeekDays(savedWeekDays);
              habitRecurrenceCubit.setMonthDays(savedMonthDays);
              habitRecurrenceCubit.setPages(savedLastPage);
            }
          }
        );
    }

class SetInterval extends StatelessWidget {
  final String value;
  const SetInterval({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: SizedBox(
      width: 210,
      child: Row(
        children: <Widget>[
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          const Spacer(),
          BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
            builder: (context, state) {
              final selectedValue = state.recurrenceValue;
              return FilledRadioButton<String>(
                  value: value,
                  groupValue: selectedValue,
                  onChanged: (newValue) {
                    context
                        .read<HabitRecurrenceCubit>()
                        .setRecurrenceValue(newValue!);
                  });
            },
          ),
          const SizedBox(
            width: 35,
          ),
        ],
      ),
    ),
  );
  }
}

class IntervalPage extends StatelessWidget {
  const IntervalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 54),
      child: Row(
        children: [
        Column(
          children: <Widget>[
            SetInterval(value: 'Every Day'),               //TODO add a feature so the user can select the values them selfs
            SetInterval(value: 'Every 3 Days'),
            SetInterval(value: 'Every 2 Weeks'),
            SetInterval(value: 'Every 1 Month'),
          ],
        ),
      ]),
    );
  }
}

class BuildWeekList extends StatelessWidget {
  final String day;
  const BuildWeekList({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 160,
        child: Row(
          children: <Widget>[
            Text(day,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
            const Spacer(),
            SizedBox(
              height: 24,
              width: 24,
              child: BlocBuilder<HabitRecurrenceCubit,
                  HabitRecurrenceState>(
                builder: (context, state) {
                  final weekDays = state.weekDays;
                  return Checkbox(                                         //TODO make the check boxes easier to click, something like a gesture detector for the whole line
                      value: weekDays[day],
                      activeColor: MyColors().primaryColor,
                      checkColor: MyColors().backgroundColor,
                      onChanged: (newBool) {
                        context
                            .read<HabitRecurrenceCubit>()
                            .setWeekDayValue(day, newBool!);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekPage extends StatelessWidget {
  const WeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54),
      child: Row(
        children: [
          Column(
            children: [
              const SizedBox(height: 4),
              for (String day in context
                  .read<HabitRecurrenceCubit>()
                  .state
                  .weekDays
                  .keys)
                BuildWeekList(day: day)
            ],
          ),
        ],
      ),
    );
  }
}

class MonthPage extends StatelessWidget {
  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 53),
      child: Column(children: [
        const SizedBox(height: 7),
        SizedBox(
          height: null,
          child: BlocBuilder<HabitRecurrenceCubit, HabitRecurrenceState>(
            builder: (context, state) {
              return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 6,
                shrinkWrap: true,
                children: List.generate(32, (index) {
                  final isSafe = state.monthDays.containsKey(index + 1) ? state.monthDays[index + 1] : false;
                  return Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSafe! ? MyColors().primaryColor : MyColors().backgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        bool hasOtherKeys = false;
                        if (isSafe) {
                            for (var key in context.read<HabitRecurrenceCubit>().state.monthDays.keys) {
                              if (key != index + 1) {
                                  hasOtherKeys = true;
                                  break; // No need to continue checking if we already found one.
                              }
                            }
                          if (hasOtherKeys) {
                              context.read<HabitRecurrenceCubit>().monthDaysRemove(index + 1);
                          } 
                          else {
                            print('no keys'); 
                          }
                        } 
                        else {
                          context.read<HabitRecurrenceCubit>().monthDaysAdd(index + 1);
                        }
                      //print(monthDays);
                          
                      },
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          '${index + 1}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSafe ? Colors.black : const Color.fromRGBO(183, 183, 183, 1),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          )
        ),
      ]),
    );
  }
}

class SaveRecurrenceButton extends StatelessWidget {
  final VoidCallback onTap;
  const SaveRecurrenceButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text('SAVE',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: MyColors().primaryColor)),
    );
  }
}

class RecurrenceSelect extends StatelessWidget {
  const RecurrenceSelect({super.key});

  @override
  Widget build(BuildContext context) {
  return BlocBuilder<HabitFormCubit, HabitFormState>(
      builder: (context, state) {
        String recurrenceTextFull;
        int counter = 9;
        if(state.recurrenceSet.length <= counter){
          recurrenceTextFull = state.recurrenceSet.substring(0,state.recurrenceSet.length);
        }
        else{
          recurrenceTextFull = "${state.recurrenceSet.substring(0,counter)}...";
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: <Widget>[
            SizedBox(
                width: 90,
                child: Text(recurrenceTextFull,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Icon(Icons.expand_more_rounded,
                  color: MyColors().lightGrey, size: 32),
            ),
          ]),
        );
      },
    );
  }
}