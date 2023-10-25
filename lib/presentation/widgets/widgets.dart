import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:intl/intl.dart';

import '../../logic/cubits/date_select_cubit_cubit.dart';
import '../pages/home_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: BlocBuilder<DateSelectCubit, DateSelectState>(
        builder: (context, state) {
          return Text(
              DateFormat("dd.MM.yyyy").format(context
                          .read<DateSelectCubit>()
                          .state
                          .selectedDate!) ==
                      DateFormat("dd.MM.yyyy").format(DateTime.now())
                  ? "Today"
                  : DateFormat("dd.MM.yyyy").format(context.read<DateSelectCubit>().state.selectedDate!),
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white));
        },
      ),
      leadingWidth: 70,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: MyColors().backgroundColor,
      elevation: 0,
      actions: [
        Row(children: <Widget>[
          IconButton(
            onPressed: () {
              //TODO: Implement search
            },
            icon: const Icon(Icons.search_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 9),
            child: IconButton(
              onPressed: () {
                //TODO: Implement filter
              },
              icon: const Icon(Icons.filter_list_rounded),
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewHabitAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewHabitAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: const Text("New Habit",
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

class InputWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;
  final Widget child;
  final VoidCallback onTap;
  const InputWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.width,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          width: width,
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
    );
  }
}

class TextInput extends StatelessWidget {
  final String placeholder;
  final String name;
  final void Function(String val) onChanged;

  const TextInput(
      {super.key,
      required this.placeholder,
      required this.name,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
            keyboardType:
                name == 'Goal' ? TextInputType.number : TextInputType.text,
            cursorColor: MyColors().secondaryColor,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: TextStyle( 
                  color: MyColors().placeHolderColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            onChanged: onChanged),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;
  const SubmitButton(
      {super.key,
      required this.text,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: SizedBox(
        height: 51,
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors().primaryColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: onPressed,
          child: Text(text,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class TimeSelect extends StatelessWidget {
  const TimeSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitFormCubit, HabitFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: <Widget>[
            SizedBox(
                width: 36,
                child: Text(
                    state.time != null
                        ? "${state.time!.hour.toString()}:${state.time!.minute.toString()}"
                        : "time",
                    style: TextStyle(
                        color: state.time != null
                            ? Colors.white
                            : MyColors().placeHolderColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(Icons.expand_more_rounded,
                  color: MyColors().lightGrey, size: 32),
            ),
          ]),
        );
      },
    );
  }
}

class DateSelect extends StatelessWidget {
  const DateSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitFormCubit, HabitFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: <Widget>[
            SizedBox(
                width: 76,
                child: Text(
                    DateFormat('yyyy/MM/dd').format(state.selectedDate!),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(Icons.expand_more_rounded,
                  color: MyColors().lightGrey, size: 32),
            ),
          ]),
        );
      },
    );
  }
}

class TimeDelete extends StatelessWidget {
  const TimeDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitFormCubit, HabitFormState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.time != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: () {
              context.read<HabitFormCubit>().setHabitTime(null);
              context.read<HabitFormCubit>().toggleHabitNotify(false);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                  height: 51,
                  width: 55,
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
                  child: Icon(Icons.delete_forever_rounded,
                      color: MyColors().lightGrey, size: 20)),
            ),
          ),
        );
      },
    );
  }
}

class NotifyToggle extends StatelessWidget {
  final GlobalKey<ShakeWidgetState> shakeTimeKey;
  const NotifyToggle({super.key, required this.shakeTimeKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitFormCubit, HabitFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 30,
                  child: Text(state.notify ? "Yes" : "No",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              const SizedBox(width: 20),
              FlutterSwitch(
                  value: state.notify,
                  width: 60.0,
                  height: 24.0,
                  toggleSize: 24,
                  padding: 0,
                  activeColor: MyColors().backgroundColor,
                  inactiveColor: MyColors().backgroundColor,
                  toggleColor: MyColors().primaryColor,
                  onToggle: (bool valueChange) {
                    state.time != null
                        ? null
                        : shakeTimeKey.currentState?.shake();
                    state.time != null
                        ? context
                            .read<HabitFormCubit>()
                            .toggleHabitNotify(valueChange)
                        : context
                            .read<HabitFormCubit>()
                            .toggleHabitNotify(false);
                  }),
            ],
          ),
        );
      },
    );
  }
}
