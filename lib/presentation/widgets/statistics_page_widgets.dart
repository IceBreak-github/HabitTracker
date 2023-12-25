import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/pages/home_page.dart';
import 'package:habit_tracker/presentation/widgets/home_page_widgets.dart';
import 'package:habit_tracker/presentation/widgets/widgets.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

//TODO habits which have a recurrence of null are not counted, should that be changed? probably not, but the user should be informed

int countWeekdaysBetween(DateTime startDate, DateTime endDate, int targetWeekday) {
  int difference = endDate.difference(startDate).inDays;
  double numberOfWeeks = (difference + startDate.weekday) / 7 + 1;
  int endDayIndex = (difference + startDate.weekday) % 7;
  return (numberOfWeeks + (startDate.weekday > targetWeekday ? -1 : 0 ) + (endDayIndex < targetWeekday  ? -1 : 0)).toInt();
}

int calculateCompletionLength(Habit habit, DateTime currentDate){               //TODO find a better solution
  int completionLength = 0;
  for(String thisDate in habit.completionDates.keys){
      final parts = thisDate.split('.');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      if(DateTime(year, month, day).isBefore(currentDate) || DateTime(year, month, day).isAtSameMomentAs(currentDate)){
        completionLength++;
      }
  }
  return completionLength;
}

bool isValidDate(String input) {
  final parts = input.split('.');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final day = int.parse(parts[2]);

  final date = DateTime(year, month, day);
  final originalFormatString = DateFormat('yyyy.M.d').format(date);
  return input == originalFormatString;
}

int calculateAvgScore({required DateTime currentDate}) {
  
  List<int> allScores = [];
  for(int i = 0; i < boxHabits.length; i++){
    try{
      allScores.add(calculateHabitStreakAndRate(habit: boxHabits.getAt(i), currentDate: currentDate)[0]!);
    } catch(e){
      //do nothing
    }
  }
  double avgScore;
  if(allScores.isEmpty){
    avgScore = 0;
  }
  else{
    int allSum = allScores.reduce((a, b) => a + b);
    avgScore = allSum / allScores.length;
  }
  
  return avgScore.toInt();
}

List<int?> calculateHabitStreakAndRate({required Habit habit, required DateTime currentDate}) {
  DateTime habitDate = DateTime(habit.date['year'], habit.date['month'],habit.date['day']);
  int streak = 0;
  if(habit.recurrence == null){
    return [null,null];
  }
  if(habit.recurrence is String && habit.recurrence == 'Every Day'){
    int difference = currentDate.difference(habitDate).inDays;
    while (habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(currentDate.subtract(Duration(days: 1 + streak)))) && habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(currentDate))) {
      streak++;
    }
    if(habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(currentDate))){
      streak++;
    }
    int completionLength = calculateCompletionLength(habit, currentDate);
    double procentage = 0;
    if(difference+1 != 0){
      procentage = completionLength / (difference+1);  //date difference plus today 
    }
    procentage = procentage * 100;
    return [procentage.toInt(), streak];
  }
  if(habit.recurrence is Map){
    if(habit.recurrence.containsKey("interval")){
      int gap = habit.recurrence['interval'];
      DateTime nearestDate = currentDate.subtract(Duration(days: currentDate.difference(habitDate).inDays % gap));
      int difference = nearestDate.difference(habitDate).inDays;
      while (habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(nearestDate.subtract(Duration(days: gap * streak))))) {
        streak++;
      }
      int completionLength = calculateCompletionLength(habit, currentDate);
      int totalPossibleCompletions = ((difference+1) / gap).ceil();  //rounds all the totalPossibleCompletions Up
      double procentage = 0;
      if(totalPossibleCompletions != 0){
        procentage = completionLength / totalPossibleCompletions;
      }
      procentage = procentage * 100;
      return [procentage.toInt(), streak];
    }
    else if(habit.recurrence.containsKey("Monday")){
      int totalPossibleCompletions = 0;
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
          String formattedDateString = DateFormat('yyyy.M.d').format(formattedDate);
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
      int completionLength = calculateCompletionLength(habit, currentDate);
      double procentage = 0;
      if(totalPossibleCompletions != 0){
        procentage = completionLength / totalPossibleCompletions;
      }
      procentage = procentage * 100;
      return [procentage.toInt(), streak];
      
    }
    if (habit.recurrence.keys.every((key) => key is int)){
      int totalPossibleCompletions = 0;
      List daysToCheck = [];
      for (int day in habit.recurrence.keys) {
        DateTime? nowDate = isValidDate("${habitDate.year}.${habitDate.month}.$day") ? DateTime(habitDate.year, habitDate.month, day) : null;
        if(nowDate != null){
          if(isValidDate("${nowDate.year}.${nowDate.month}.$day")){
            daysToCheck.add(DateTime(nowDate.year, nowDate.month, day));
            //print('Adding ${DateTime(nowDate.year, nowDate.month, day)}');
          }
          while (nowDate!.isBefore(currentDate) || nowDate.isAtSameMomentAs(currentDate)) {   
            totalPossibleCompletions++;  
            nowDate = DateTime(nowDate.year, nowDate.month + 1, day);
          }
        }
      }
      daysToCheck.sort((a, b) {
        bool aAfterCurrent = a.isAfter(currentDate);
        bool bAfterCurrent = b.isAfter(currentDate);

        if (aAfterCurrent && bAfterCurrent) {
          // Both are after the current date, sort in descending order
          return b.compareTo(a);
        } else if (aAfterCurrent) {
          // a is after current date, prioritize it (descending order)
          return -1;
        } else if (bAfterCurrent) {
          // b is after current date, prioritize it (descending order)
          return 1;
        } else {
          // Sort in ascending order of proximity to the current date
          Duration differenceA = a.difference(currentDate).abs();
          Duration differenceB = b.difference(currentDate).abs();

          return differenceA.compareTo(differenceB);
        }
      });
      calculateStreak({int iteration = 0}) {
        for (DateTime date in daysToCheck){
          if(isValidDate("${currentDate.year}.${currentDate.month - iteration}.${date.day}")){
            DateTime nowDate = DateTime(currentDate.year, currentDate.month - iteration, date.day);
            if(nowDate.isBefore(currentDate)){
              if(habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(nowDate))){ 
                streak++;
              }
              else{
                return;
              }
            }
          }
        }
        calculateStreak(iteration: iteration+1);
      }
      calculateStreak();
      int completionLength = calculateCompletionLength(habit, currentDate);
      double procentage = 0;
      if(totalPossibleCompletions != 0){
        procentage = completionLength / totalPossibleCompletions;
      }
      procentage = procentage * 100;
      return [procentage.toInt(), streak];
    }
  }
  return [0,0];
}

class StatisticsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const StatisticsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: MyColors().backgroundColor,
      ),
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
      actions: const [         //TODO icons are not spaced evenly like on the HomePage, fix later
        Row(
          children: <Widget>[
          Icon(
            Icons.search_rounded,
          ),
          OrderHabits(),
          
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
    int avgScore = calculateAvgScore(currentDate: DateTime.now());
    int last30DaysScore = avgScore - calculateAvgScore(currentDate: DateTime.now().subtract(const Duration(days: 30)));
    int last7DaysScore = avgScore - calculateAvgScore(currentDate: DateTime.now().subtract(const Duration(days: 7)));
    ValueNotifier<double> overAllScore = ValueNotifier(avgScore.toDouble());
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
          padding: const EdgeInsets.only(left: 26, right: 26, top: 26),
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
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 0),
                child: Row(
                  children: <Widget> [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 6),
                      child: SimpleCircularProgressBar(
                        size: 40,
                        progressColors: [MyColors().primaryColor],
                        progressStrokeWidth: 11,
                        backStrokeWidth: 11,
                        backColor: const Color.fromRGBO(45, 45, 59, 1),
                        mergeMode: true,
                        animationDuration: 3,
                        valueNotifier: overAllScore,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text('$avgScore%', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 7),
                        Text('Score', style: TextStyle(color: MyColors().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            last30DaysScore >= 0 ? Text('+', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.bold)) : Container(),
                            Text('$last30DaysScore%', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text('Month', style: TextStyle(color: MyColors().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            last7DaysScore >= 0 ? Text('+', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.bold)) : Container(),
                            Text('$last7DaysScore%', style: TextStyle(color: MyColors().primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text('Week', style: TextStyle(color: MyColors().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
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
            child: Text('Recurrent Habits', style: TextStyle(color: Color.fromRGBO(81,81,81, 1), fontSize: 12)),
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
            padding: const EdgeInsets.only(top: 2, left: 4),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 2),
                  child: Row(
                    children: [
                      SimpleCircularProgressBar(
                        size: 13,
                        progressColors: [MyColors().secondaryColor],
                        progressStrokeWidth: 4,
                        backStrokeWidth: 4,
                        backColor: const Color.fromRGBO(45, 45, 59, 1),
                        mergeMode: true,
                        animationDuration: 3,
                        valueNotifier: ValueNotifier(calculateHabitStreakAndRate(habit: habit, currentDate: DateTime.now())[0]!.toDouble()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: SizedBox(width: 32,child: Text('${calculateHabitStreakAndRate(habit: habit, currentDate: DateTime.now())[0]}%', style: TextStyle(color: MyColors().secondaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
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
                      child: SizedBox(width: 32, child: Text('${calculateHabitStreakAndRate(habit: habit, currentDate: DateTime.now())[1]}', style: TextStyle(color: MyColors().secondaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
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
            bool selected = habit.completionDates.containsKey(DateFormat('yyyy.M.d').format(thisDate));

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  children: <Widget> [
                    Text(DateFormat('E').format(thisDate).substring(0, 2), style: TextStyle(color: MyColors().lightGrey, fontSize: 11, fontWeight: FontWeight.w500)),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),       
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