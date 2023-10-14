import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/presentation/widgets/button_widgets.dart';
import 'package:habit_tracker/shared/colors.dart';

import '../../logic/cubits/habit_form_cubit.dart';
import '../../logic/cubits/habit_recurrence_cubit.dart';
import '../../logic/cubits/habit_setting_cubit.dart';
import '../pages/newhabit_page.dart';

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

class HabitSetting extends StatelessWidget {
  // sets the habit to recurrent and trackable
  final bool value;
  final String text;
  final IconData icon;

  const HabitSetting(
      {super.key, required this.value, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Icon(
              icon,
              color: MyColors().secondaryColor,
              size: 24.0,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          const Spacer(),
          FlutterSwitch(
              value: value,
              width: 60.0,
              height: 24.0,
              toggleSize: 24,
              padding: 0,
              activeColor: MyColors().backgroundColor,
              inactiveColor: MyColors().backgroundColor,
              toggleColor: MyColors().primaryColor,
              onToggle: (bool valueChange) {
                final habitSettingState =
                    context.read<HabitSettingCubit>().state;
                context.read<HabitSettingCubit>().updateSettings(
                    trackable: text == 'Trackable'
                        ? valueChange
                        : habitSettingState.trackable,
                    recurrent: text == 'Recurrent'
                        ? valueChange
                        : habitSettingState.recurrent);
              }),
        ],
      ),
    );
  }
}

class HabitSettingsWindow extends StatefulWidget {
  const HabitSettingsWindow({super.key});

  @override
  State<HabitSettingsWindow> createState() => _HabitSettingsWindowState();
}

class _HabitSettingsWindowState extends State<HabitSettingsWindow> {
  habitType(String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Icon(
              icon,
              color: MyColors().secondaryColor,
              size: 24.0,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          const Spacer(),
          BlocBuilder<HabitSettingCubit, HabitSettingState>(
            builder: (context, habitTypeState) {
              final selectedValue = (habitTypeState).habitType;

              return FilledRadioButton<String>(
                value: value,
                groupValue: selectedValue,
                onChanged: (newValue) {
                  context.read<HabitSettingCubit>().updateHabitType(newValue!);
                },
              );
            },
          ),
          const SizedBox(
            width: 35,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        habitType('Measurement', Icons.scale_rounded),
        habitType('Yes or No', Icons.flaky_rounded),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Divider(
            color: MyColors().darkGrey,
          ),
        ),
        BlocBuilder<HabitSettingCubit, HabitSettingState>(
          builder: (context, state) {
            return HabitSetting(
                value: state.trackable,
                text: 'Trackable',
                icon: Icons.query_stats_rounded);
          },
        ),
        BlocBuilder<HabitSettingCubit, HabitSettingState>(
          builder: (context, state) {
            return HabitSetting(
              value: state.recurrent,
              text: 'Recurrent',
              icon: Icons.change_circle,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 170,
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors().primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                final habitSettingState =
                    context.read<HabitSettingCubit>().state;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider<HabitFormCubit>(
                              create: (context) => HabitFormCubit(),
                            ),
                            BlocProvider<HabitRecurrenceCubit>(
                              create: (context) => HabitRecurrenceCubit(),
                            ),
                          ],
                          child: NewHabitPage(
                            habitType: habitSettingState.habitType,
                            trackable: habitSettingState.trackable,
                            recurrent: habitSettingState.recurrent,
                          ),
                        )));
              },
              child: const Text("OK",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }
}
