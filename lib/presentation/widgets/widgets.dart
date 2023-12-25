import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/cubits/habit_form_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/logic/services/habit_service.dart';
import 'package:habit_tracker/presentation/pages/settings_page.dart';
import 'package:habit_tracker/presentation/pages/statistics_page.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:habit_tracker/shared/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../pages/home_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: MyColors().backgroundColor,
      ),
      title: BlocBuilder<HabitHomeCubit, HabitHomeState>(
        builder: (context, state) {
          return Text(
              DateFormat("dd.M.yyyy").format(
                          context.read<HabitHomeCubit>().state.selectedDate!) ==
                      DateFormat("dd.M.yyyy").format(DateTime.now())
                  ? "Today"
                  : DateFormat("dd.M.yyyy").format(
                      context.read<HabitHomeCubit>().state.selectedDate!),
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
        BlocBuilder<HabitHomeCubit, HabitHomeState>(
          builder: (context, state) {
            List<int> pastShownHabitIndexes = state.shownHabitIndexes;
            return Row(children: <Widget>[
              IconButton(
                onPressed: () {
                  if (context.read<HabitHomeCubit>().state.isSearched ==
                      false) {
                    context.read<HabitHomeCubit>().setSearch(true);
                    context
                        .read<HabitHomeCubit>()
                        .handleSearch(pastShownHabitIndexes);
                    showCustomDialog(context);
                  }
                },
                icon: const Icon(Icons.search_rounded),
              ),
              const OrderHabits(),
            ]);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewHabitAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Habit? habit;
  const NewHabitAppBar({
    super.key,
    this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: MyColors().backgroundColor,
      ),
      toolbarHeight: 70,
      title: Text(habit != null ? habit!.name : "New Habit",
          style: const TextStyle(
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
        habit != null
            ? Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () async {
                    if (habit!.notify == true) {
                      List sharedPreferencesValues = await StoredNotifications.decodeSharedPreferences(name: habit!.name);
                      Map<String, int> decodedSchedule = sharedPreferencesValues[0];
                      if (decodedSchedule.isNotEmpty) {
                        for (int scheduleId in decodedSchedule.values) {
                          AwesomeNotifications().cancel(scheduleId);
                        }
                      }
                      await StoredNotifications.removeNotification(habitName: habit!.name);
                    }
                    
                    boxHabits.delete(habit!.key);
                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider<HabitHomeCubit>(
                              create: (context) => HabitHomeCubit(),
                            ),
                          ],
                          child: const HomePage(),
                        ))
                      );
                    }
                  },
                ),
              )
            : Container()
      ],
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
  final String? initialValue;
  final void Function(String val) onChanged;

  const TextInput({
    super.key,
    required this.placeholder,
    required this.name,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
            initialValue: initialValue,
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

class OrderHabits extends StatelessWidget {
  const OrderHabits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: PopupMenuButton<String>(
          color: const Color.fromRGBO(20, 20, 20, 1),
          icon: const Icon(Icons.filter_list_rounded,
              color: Colors.white), //TODO implement ordering
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                enabled: false,
                value: 'Order by',
                child: Row(
                  children: [
                    Text('Order Habits:',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    Spacer(),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  context.read<HabitHomeCubit>().handleSelectedDateChange(context.read<HabitHomeCubit>().state.selectedDate!);
                },
                value: 'Automatic',
                child: const Row(
                  children: [
                    Text('Automatic',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    Spacer(),
                    Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 13,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  List<int> currentList = orderHabitsByAlphabet(currentList: context.read<HabitHomeCubit>().state.shownHabitIndexes, selectedDate: context.read<HabitHomeCubit>().state.selectedDate!);
                  context.read<HabitHomeCubit>().handleReOrder(currentList);
                },
                value: 'Alphabetic',
                child: const Text('Alphabetic',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  List<int> currentList = orderHabitsByDate(currentList: context.read<HabitHomeCubit>().state.shownHabitIndexes, selectedDate: context.read<HabitHomeCubit>().state.selectedDate!);
                  context.read<HabitHomeCubit>().handleReOrder(currentList);
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
                  List<int> currentList = orderHabitsByTime(currentList: context.read<HabitHomeCubit>().state.shownHabitIndexes, selectedDate: context.read<HabitHomeCubit>().state.selectedDate!);
                  context.read<HabitHomeCubit>().handleReOrder(currentList);
                },
                value: 'By Time',
                child: const Text('By Time',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  List<int> currentList = orderHabitsByCompletion(currentList: context.read<HabitHomeCubit>().state.shownHabitIndexes, selectedDate: context.read<HabitHomeCubit>().state.selectedDate!);
                  context.read<HabitHomeCubit>().handleReOrder(currentList);
                },
                value: 'By Completion',
                child: const Row(
                  children: [
                    Text('By Completion',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ];
          }),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: ListView(children: [
              Container(
                height: 85,
              ),
              Divider(
                color: MyColors().lightGrey,
              ),
              const SizedBox(height: 26),
              Wrap(
                runSpacing: 5,
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.event_available_rounded, size: 24),
                    title: const Text('Today',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    iconColor: MyColors().lightGrey,
                    selectedColor: MyColors().secondaryColor,
                    textColor: MyColors().lightGrey,
                    selectedTileColor: MyColors().widgetColor,
                    selected: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                  NavTile(
                      text: 'Statistics',
                      icon: Icons.query_stats_rounded,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StatisticsPage()));
                      }),
                  Divider(
                    color: MyColors().lightGrey,
                  ),
                  NavTile(
                      text: 'Settings',
                      icon: Icons.tune_rounded,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider<HabitSettingsCubit>(
                                create: (context) => HabitSettingsCubit(),
                              ),
                            ],
                            child: const SettingsPage(),
                          ))
                        );
                      }),
                  Divider(
                    color: MyColors().lightGrey,
                  ),
                  NavTile(
                      text: 'Rate this app',
                      icon: Icons.star_rounded,
                      onTap: () {}),
                  NavTile(
                      text: 'Premium',
                      icon: Icons.verified_rounded,
                      onTap: () {}),
                  Divider(
                    color: MyColors().lightGrey,
                  ),
                  NavTile(
                      text: 'About', icon: Icons.info_rounded, onTap: () {}),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class NavTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const NavTile(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: MyColors().lightGrey, size: 24),
      title: Text(text,
          style: TextStyle(
              color: MyColors().lightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
      iconColor: MyColors().lightGrey,
      selectedColor: MyColors().secondaryColor,
      textColor: MyColors().lightGrey,
      selectedTileColor: MyColors().widgetColor,
      selected: false,
      splashColor: MyColors().widgetColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTap,
    );
  }
}

void showCustomDialog(BuildContext context) {
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  AnimationController controller = AnimationController(
    vsync: Overlay.of(context),
    duration:
        const Duration(milliseconds: 300), // Adjust the duration as needed
  );

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1), // Slide from top
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.fastOutSlowIn,
        )),
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColors().backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: BlocBuilder<HabitHomeCubit, HabitHomeState>(
                          builder: (context, state) {
                            BuildContext myContext = context;
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 23),
                                  child: Icon(Icons.search,
                                      color: MyColors().primaryColor, size: 20),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        focusNode: focusNode,
                                        cursorColor: MyColors().secondaryColor,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: 'Search Habits...',
                                          hintStyle: TextStyle(
                                              color:
                                                  MyColors().placeHolderColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        onChanged: (value) {
                                          List<int> updatedShownHabitIndexes =
                                              [];
                                          var unfilteredValues = boxHabits
                                              .values
                                              .map((habit) => habit.key)
                                              .toList();
                                          if (value.isEmpty) {
                                            // if the search field is empty or only contains white-space, we'll display all habits
                                            updatedShownHabitIndexes =
                                                state.shownHabitIndexes;
                                          } else {
                                            for (int i = 0; i < unfilteredValues.length; i++) {
                                              Habit habit = boxHabits.get(unfilteredValues[i]);
                                              if (habit.name
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase())) {
                                                if (!showHabitOrNot(
                                                    recurrence:
                                                        habit.recurrence,
                                                    habitDate: habit.date,
                                                    newDate:
                                                        state.selectedDate!)) {
                                                  DateTime goToDate = calculateNearestFutureRecurrence(habit: habit, currentDate: state.selectedDate!);
                                                  myContext.read<HabitHomeCubit>().cleanHomeCubit(DateFormat('yyyy.M.d').format(state.selectedDate!));
                                                  myContext
                                                      .read<HabitHomeCubit>()
                                                      .selectDate(goToDate);
                                                }
                                                updatedShownHabitIndexes
                                                    .add(habit.key);
                                              }
                                            }
                                            // we use the toLowerCase() method to make it case-insensitive
                                          }
                                          context
                                              .read<HabitHomeCubit>()
                                              .handleSearch(
                                                  updatedShownHabitIndexes);
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: SizedBox(
                                    width: 27,
                                    child: RawMaterialButton(
                                      elevation: 0,
                                      shape: const CircleBorder(),
                                      fillColor:
                                          MyColors().darkGrey.withOpacity(0.2),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(Icons.expand_less_rounded,
                                            color: MyColors().lightGrey,
                                            size: 20),
                                      ),
                                      onPressed: () {
                                        myContext
                                            .read<HabitHomeCubit>()
                                            .cleanHomeCubit(
                                                DateFormat('yyyy.M.d').format(
                                                    state.selectedDate!));
                                        myContext
                                            .read<HabitHomeCubit>()
                                            .selectDate(DateTime.now());
                                        myContext
                                            .read<HabitHomeCubit>()
                                            .setSearch(false);
                                        controller
                                            .reverse(); // Reverse the animation
                                        Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                            try {
                                              overlayEntry!.remove();
                                              controller
                                                  .dispose(); // Dispose of the controller
                                              focusNode.unfocus();
                                            } catch (e) {
                                              //nothing
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  try {
    Overlay.of(context).insert(overlayEntry);
    controller.forward();
    focusNode.requestFocus();
  } catch (e) {
    //nothing
  }
}

class NothingHere extends StatelessWidget {
  const NothingHere({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.15),
      child: Center(
        child: Column(
          children: <Widget> [
            Icon(
              Icons.import_contacts_outlined,
              size: 80,
              color: MyColors().widgetColor,
            ),
            const SizedBox(height: 30),
            const Text('No habits scheduled', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            Text('Add some more !', style: TextStyle(fontSize: 14, color: MyColors().lightGrey, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
