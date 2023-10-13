import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/shared/colors.dart';

import 'button_widgets.dart';

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
            SetInterval(value: 'Every Day'),
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
                  return Checkbox(
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