import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/data/models/settings_model.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
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
      actions: [
        Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: 15),
              icon: const Icon(Icons.settings_backup_restore),
              onPressed: () {
                context.read<HabitSettingsCubit>().restoreSettings();
              }
            ),
          ],
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SettingsWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget child;
  final VoidCallback onTap;
  const SettingsWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FittedBox(
          child: Container(
            height: 51,
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
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  icon,
                  color: MyColors().secondaryColor,
                  size: 20,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: MyColors().lightGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child
            ]),
          ),
        ),
      ),
    );
  }
}

class ToggleNotifications extends StatelessWidget {
  const ToggleNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    Settings settings = boxSettings.get(0);
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
                    settings.notifications = !settings.notifications;
                    boxSettings.put(0, settings);
                    context.read<HabitSettingsCubit>().toggleNotifications(valueChange);
                  }),
              const SizedBox(width: 5),
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
    Settings settings = boxSettings.get(0);
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
                    settings.vibrations = !settings.vibrations;
                    boxSettings.put(0, settings);
                    context.read<HabitSettingsCubit>().toggleVibrations(valueChange);
                  }),
              const SizedBox(width: 5),
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
    Settings settings = boxSettings.get(0);
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
                      settings.orderHabits = 'Automat.';
                      boxSettings.put(0, settings);
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
                      settings.orderHabits = 'Alphabet.';
                      boxSettings.put(0, settings);
                      context.read<HabitSettingsCubit>().setHabitOrder('Alphabet.');
                    },
                    value: 'Alphabetic',
                    child: const Text('Alphabetic',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      settings.orderHabits = 'By Date';
                      boxSettings.put(0, settings);
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
                      settings.orderHabits = 'By Time';
                      boxSettings.put(0, settings);
                      context.read<HabitSettingsCubit>().setHabitOrder('By Time');
                    },
                    value: 'By Time',
                    child: const Text('By Time',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      settings.orderHabits = 'By Compl.';
                      boxSettings.put(0, settings);
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
                  padding: const EdgeInsets.only(left: 7, right: 17),
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
    Settings settings = boxSettings.get(0);
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
                    settings.setWidget = !settings.setWidget;
                    boxSettings.put(0, settings);
                    context.read<HabitSettingsCubit>().toggleWidget(valueChange);
                  }),
              const SizedBox(width: 5),
            ],
          ),
        );
      },
    );
  } 
}

class SelectTheme extends StatelessWidget {
  const SelectTheme({super.key});

  @override
  Widget build(BuildContext context) {
    Settings settings = boxSettings.get(0);
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
                      settings.theme = 'Dark';
                      boxSettings.put(0, settings);
                      context.read<HabitSettingsCubit>().setTheme('Dark');
                    },
                    value: 'Dark',
                    child: const Row(
                      children: [
                        Text('Dark',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        Spacer(),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      settings.theme = 'White';
                      boxSettings.put(0, settings);
                      context.read<HabitSettingsCubit>().setTheme('White');
                    },
                    value: 'White',
                    child: const Text('White',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
              ],
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: Text(state.theme, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 17),
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

showColorPicker({required BuildContext context, required Color pickerColor, required void Function(Color) onColorChanged}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker( //TODO restyle the package, other picker widgets as well
          //hexInputBar: true,
          pickerAreaHeightPercent: 0.7,
          labelTypes: const [ColorLabelType.hex, ColorLabelType.rgb],
          pickerColor: pickerColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 17),
          child: ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              //setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
    },
  );
}

class ColorDisplay extends StatelessWidget {
  final String colorString;
  final double width;
  const ColorDisplay({
    super.key,
    required this.colorString,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitSettingsCubit, HabitSettingsState>(
      builder: (context, state) {

        Color getColorValue(String color){
          if(color == 'primaryColor'){
            return state.primaryColor!;
          }
          if(color == 'secondaryColor'){
            return state.secondaryColor!;
          }
          if(color == 'backgroundColor'){
            return state.backgroundColor!;
          }
          if(color == 'widgetColor'){
            return state.widgetColor!;
          }
          //this should never happen
          return Colors.black;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Text(getColorValue(colorString).value.toRadixString(16),
              overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 20),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColorValue(colorString),
                    border: Border.all(color: MyColors().backgroundColor),
                    boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 5  horizontally
                        0.0, // Move to bottom 5 Vertically
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),  //TODO make these paddings the same across all pages and all widgets
            ],
          ),
        );
      },
    );
  } 
}