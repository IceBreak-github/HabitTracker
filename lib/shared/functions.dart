import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_recurrence_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_setting_cubit.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/presentation/widgets/recurrence_panel_widgets.dart';
import 'package:habit_tracker/shared/colors.dart';


createHabitPopUp(BuildContext context) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Create a Habit",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: MyColors().widgetColor,
          titlePadding: const EdgeInsets.only(top: 40),
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.only(top: 15),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                height: 355,
                width: width - 50,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<HabitSettingCubit>(
                        create: (context) => HabitSettingCubit(),
                      ),
                    ],
                    child: const HabitSettingsWindow(),
                  ),
                ),
              );
            },
          ),
        );
      });
}

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
                        height: 31,
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
                        height: 31,
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
                        height: 31,
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
