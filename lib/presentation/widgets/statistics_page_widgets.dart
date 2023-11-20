import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/presentation/widgets/home_page_widgets.dart';
import 'package:habit_tracker/presentation/widgets/widgets.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:intl/intl.dart';

List<int> calculateHabitStreakAndRate({required Habit habit}) {
  DateTime habitDate = DateTime(habit.date['year'], habit.date['month'],habit.date['day']);
  DateTime currentDate = DateTime.now();
  if(habit.recurrence is String && habit.recurrence == 'Every Day'){
    int difference = currentDate.difference(habitDate).inDays;
    int streak = 0;
    while (habit.completionDates.containsKey(DateFormat('yyyy.MM.d').format(currentDate.subtract(Duration(days: 1 + streak)))) && habit.completionDates.containsKey(DateFormat('yyyy.MM.dd').format(currentDate))) {
      streak++;
    }
    if(habit.completionDates.containsKey(DateFormat('yyyy.MM.d').format(currentDate))){
      streak++;
    }
    double procentage = habit.completionDates.length / (difference+1);   //date difference plus today 
    procentage = procentage * 100;
  
    return [procentage.toInt(), streak];
  }
  if(habit.recurrence is Map){
    if(habit.recurrence.containsKey("interval")){
      int gap = habit.recurrence['interval'];
      DateTime nearestDate = currentDate.subtract(Duration(days: currentDate.difference(habitDate).inDays % gap));
      int difference = nearestDate.difference(habitDate).inDays;

      int streak = 0;
      while (habit.completionDates.containsKey(DateFormat('yyyy.MM.d').format(nearestDate.subtract(Duration(days: gap * streak))))) {
        streak++;
      }
      int totalPossibleCompletions = ((difference+1) / gap).ceil();  //rounds all the totalPossibleCompletions Up
      double procentage = habit.completionDates.length / totalPossibleCompletions;
      procentage = procentage * 100;
      return [procentage.toInt(), streak];
    }
    else if(habit.recurrence.containsKey("Monday")){
      int difference = currentDate.difference(habitDate).inDays;
      int totalPossibleCompletions = 0;
      int streak = 0;
      Map<String, int> numberedWeekDays = {
        'Monday': 1,
        'Tuesday': 2,
        'Wednesday': 3,
        'Thursday': 4,
        'Friday': 5,
        'Saturday': 6,
        'Sunday': 7,
      };
      List<int> possibleCompletedDays = [];
      List<int> possibleDaysGap = [];

      int countWeekdaysBetween(DateTime startDate, DateTime endDate, int targetWeekday) {
        int days = endDate.difference(startDate).inDays + 1;
        int offset = (targetWeekday - startDate.weekday + 7) % 7;
        int totalOccurrences = 0;
        if(targetWeekday < startDate.weekday){
          totalOccurrences = ((days - offset) / 7).floor();
        }
        else{
            totalOccurrences = ((days + (7 - offset)) / 7).floor();
        }      

        return totalOccurrences >= 0 ? totalOccurrences : 0;
      }

      habit.recurrence.forEach((day, value) {
        if (value) {
          
          totalPossibleCompletions = totalPossibleCompletions + countWeekdaysBetween(habitDate, currentDate, numberedWeekDays[day]!) ;

          int daysUntilCheckDay = (currentDate.weekday - numberedWeekDays[day]! + 7) % 7;
          possibleDaysGap.add(daysUntilCheckDay);
          possibleCompletedDays.add(numberedWeekDays[day]!);
        }
      });  
      possibleDaysGap.sort();
      calculateStreak({int week = 0, int newIteration = 1}) {
        for (int i = 0; i < possibleDaysGap.length; i++) {
          int number = possibleDaysGap[i] + week;
          DateTime formattedDate = currentDate.subtract(Duration(days: number));
          String formattedDateString = DateFormat('yyyy.MM.d').format(formattedDate);
          if (habit.completionDates.containsKey(formattedDateString)) {
            streak++;
          } else {
            break;
          }
        }
        if (streak == possibleDaysGap.length * newIteration) {
          calculateStreak(week: week + 7, newIteration: newIteration + 1);
        }
      }
      calculateStreak();
      double procentage = habit.completionDates.length / totalPossibleCompletions;
      procentage = procentage * 100;
      return [procentage.toInt(), streak];
      
    }
    else if (habit.recurrence.keys.every((key) => key is int)){

    }
  }
  return [0,0];
}

class StatisticsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const StatisticsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: const Text("Statistics", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
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
          children: <Widget>[
          IconButton(
            onPressed: () {
              //TODO: Implement search
            },
            icon: const Icon(Icons.search_rounded),
          ),
          const OrderHabits(),
          
        ]),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class OverallScore extends StatelessWidget {
  const OverallScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 153,
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
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Overall Score', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    height: 19,
                    decoration: BoxDecoration(
                      color: MyColors().primaryColor.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(2))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Text('${boxHabits.length} Habits', style: TextStyle(color: MyColors().primaryColor, fontSize: 11)),
                    ),
                  ),
                ],
              ),
              Row(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsDivider extends StatelessWidget {
  const StatsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: <Widget> [
          Expanded(child: Divider(color: Color.fromRGBO(81,81,81, 1))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
            child: Text('All Habits', style: TextStyle(color: Color.fromRGBO(81,81,81, 1), fontSize: 12)),
          ),
          Expanded(child: Divider(color: Color.fromRGBO(81,81,81, 1))),
        ],
      ),
    );
  }
}

class HabitStatPanel extends StatelessWidget {
  final Habit habit;
  const HabitStatPanel({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        children: <Widget> [
          Row(
            children: <Widget> [
              Text(habit.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const Spacer(),
              Container(
                height: 19,
                decoration: BoxDecoration(
                  color: MyColors().primaryColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(2))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(computeRecurrencePanel(habit: habit)[0], style: TextStyle(color: MyColors().primaryColor, fontSize: 11)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
              InlineActivityPanel(habit: habit),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 2),
                  child: Row(
                    children: [
                      SizedBox(width: 17, height: 17, child: Image.asset('assets/temporary.png')),
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: SizedBox(width: 32,child: Text('${calculateHabitStreakAndRate(habit: habit)[0]}%', style: TextStyle(color: MyColors().secondaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: MyColors().secondaryColor, size: 18), 
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: SizedBox(width: 32, child: Text('${calculateHabitStreakAndRate(habit: habit)[1]}', style: TextStyle(color: MyColors().secondaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.task_alt, color: MyColors().secondaryColor, size: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: SizedBox(width: 32, child: Text('${habit.completionDates.length}', style: TextStyle(color: MyColors().secondaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class InlineActivityPanel extends StatelessWidget {
  final Habit habit;
  const InlineActivityPanel({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 21),
        child: Row(
          children: List.generate(7, (index) {
            int reversedIndex = 6 - index;
            DateTime thisDate = DateTime.now().subtract(Duration(days: reversedIndex));
            bool selected = habit.completionDates.containsKey(DateFormat('yyyy.MM.dd').format(thisDate));
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  children: <Widget> [
                    Text(DateFormat('E').format(thisDate).substring(0, 2), style: TextStyle(color: MyColors().lightGrey, fontSize: 11, fontWeight: FontWeight.w500)),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),       //TODO, make the whole widget space evenly inside the parent Row, starting from right to left
                      child: FractionallySizedBox(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected ? MyColors().primaryColor : MyColors().backgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(8))
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.none,
                              child: Text(
                                '${thisDate.day}',
                                maxLines: 1,
                                style: TextStyle(color: selected ? Colors.black : MyColors().lightGrey, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          ,
        ),
      ),
    );
  }
}