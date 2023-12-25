import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/colors.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: MyColors().backgroundColor,
      ),
      toolbarHeight: 70,
      title: const Text("Settings",
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
      leadingWidth: 70,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: MyColors().backgroundColor,
      elevation: 0,
      leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 26.0,
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()));
          }),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ToggleNotifications extends StatelessWidget {
  const ToggleNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitSettingsCubit, HabitSettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 30,
                  child: Text(state.notifications ? "On" : "Off",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              const SizedBox(width: 20),
              FlutterSwitch(
                  value: state.notifications,
                  width: 60.0,
                  height: 24.0,
                  toggleSize: 24,
                  padding: 0,
                  activeColor: MyColors().backgroundColor,
                  inactiveColor: MyColors().backgroundColor,
                  toggleColor: MyColors().primaryColor,
                  onToggle: (bool valueChange) {
                    //TODO also save the setting locally to a Hive box
                    context.read<HabitSettingsCubit>().toggleNotifications(valueChange);
                  }),
            ],
          ),
        );
      },
    );
  } 
}

class ToggleVibrations extends StatelessWidget {
  const ToggleVibrations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitSettingsCubit, HabitSettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 30,
                  child: Text(state.vibrations ? "On" : "Off",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              const SizedBox(width: 20),
              FlutterSwitch(
                  value: state.vibrations,
                  width: 60.0,
                  height: 24.0,
                  toggleSize: 24,
                  padding: 0,
                  activeColor: MyColors().backgroundColor,
                  inactiveColor: MyColors().backgroundColor,
                  toggleColor: MyColors().primaryColor,
                  onToggle: (bool valueChange) {
                    //TODO also save the setting locally to a Hive box
                    context.read<HabitSettingsCubit>().toggleVibrations(valueChange);
                  }),
            ],
          ),
        );
      },
    );
  } 
}

class SelectHabitOrdering extends StatelessWidget {
  const SelectHabitOrdering({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitSettingsCubit, HabitSettingsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final RenderBox button = context.findRenderObject() as RenderBox;
            await showMenu(
              color: const Color.fromRGBO(20, 20, 20, 1),
              context: context,
              position: RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset.zero),
                  button.localToGlobal(button.size.bottomRight(Offset.zero)),
                ),
                Offset.zero & MediaQuery.of(context).size,
              ),
              items: <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    onTap: () {
                      context.read<HabitSettingsCubit>().setHabitOrder('Automat.');
                    },
                    value: 'Automatic',
                    child: const Row(
                      children: [
                        Text('Automatic',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        Spacer(),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      context.read<HabitSettingsCubit>().setHabitOrder('Alphabet.');
                    },
                    value: 'Alphabetic',
                    child: const Text('Alphabetic',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      context.read<HabitSettingsCubit>().setHabitOrder('By Date');
                    },
                    value: 'By Date',
                    child: const Row(
                      children: [
                        Text('By Date',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        Spacer(),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      context.read<HabitSettingsCubit>().setHabitOrder('By Time');
                    },
                    value: 'By Time',
                    child: const Text('By Time',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      context.read<HabitSettingsCubit>().setHabitOrder('By Compl.');
                    },
                    value: 'By Completion',
                    child: const Row(
                      children: [
                        Text('By Completion',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
              ],
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 74,
                  child: Text(state.orderHabits, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: MyColors().lightGrey, size: 32
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } 
}

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitSettingsCubit, HabitSettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 30,
                  child: Text(state.setWidget ? "Yes" : "No",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              const SizedBox(width: 20),
              FlutterSwitch(
                  value: state.setWidget,
                  width: 60.0,
                  height: 24.0,
                  toggleSize: 24,
                  padding: 0,
                  activeColor: MyColors().backgroundColor,
                  inactiveColor: MyColors().backgroundColor,
                  toggleColor: MyColors().primaryColor,
                  onToggle: (bool valueChange) {
                    //TODO also save the setting locally to a Hive box
                    context.read<HabitSettingsCubit>().toggleWidget(valueChange);
                  }),
            ],
          ),
        );
      },
    );
  } 
}