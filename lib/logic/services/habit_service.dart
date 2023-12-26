import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';

bool showHabitOrNot({required dynamic recurrence, required dynamic habitDate, required DateTime newDate}) {   //habitDate expecting Map<String, int> like: "${habitDate['year']}.${habitDate['month']}.${habitDate['day']}"
  bool show = false;
  if (recurrence == null) {
    if ("${habitDate['year']}.${habitDate['month']}.${habitDate['day']}" ==
        DateFormat('yyyy.MM.d').format(newDate)) {
      show = true;
      
    }
  } else {
    if (DateTime(habitDate['year'], habitDate['month'],
            habitDate['day'])
        .isBefore(newDate)) {
      if (recurrence is String &&
          recurrence == 'Every Day') {
            show = true;
        
      }
      if (recurrence is Map &&
          recurrence.containsKey(int.parse(
              DateFormat('d').format(newDate)))) {
                show = true;
        
      }
      if (recurrence is Map &&
          recurrence.containsKey(DateFormat('EEEE').format(newDate)) && recurrence[DateFormat('EEEE').format(newDate)]) {
            show = true;
      }
      if (recurrence is Map &&
          recurrence.containsKey("interval")) {
        DateTime startDate = DateTime(
            habitDate["year"],
            habitDate['month'],
            habitDate[
                'day']); 
        Duration interval =
            Duration(days: recurrence["interval"]);
        // Calculate the difference in days between the currentDate and the startingDate
        int daysDifference =
            newDate.difference(startDate).inDays;

        // Check if the currentDate is every X day from the startingDate
        bool isEveryXDay =
            daysDifference % interval.inDays == 0;

        if (isEveryXDay) {
          show = true;
        }
      }
    }
  }
  return show;
}

DateTime calculateNearestFutureRecurrence({required Habit habit, required DateTime currentDate}) {       //returns the date of the nearest habit recurrence in the future, from the provided Date
  DateTime habitDate = DateTime(habit.date['year'], habit.date['month'],habit.date['day']);
  if(habit.recurrence == null){
    return habitDate;
  }
  if(habit.recurrence is String && habit.recurrence == 'Every Day'){
    return currentDate;
  }
  if(habit.recurrence is Map){
    if(habit.recurrence.containsKey("interval")){
      int gap = habit.recurrence['interval'];
      DateTime nearestDate = currentDate.isBefore(habitDate) ? habitDate : currentDate.add(Duration(days: habitDate.difference(currentDate).inDays % gap));
      return nearestDate;
    }
		else {
			int counter = habit.recurrence.containsKey('Monday') ? 7 : 31;  //if the recurrence is weekly, do 7, else its monthly - do 31 iterations
			for(int i = 0; i < counter; i++){
				DateTime futureDate = currentDate.isBefore(habitDate) ? habitDate.add(Duration(days: i)) : currentDate.add(Duration(days: i));
				if(showHabitOrNot(recurrence: habit.recurrence, habitDate: habit.date, newDate: futureDate)){
					return futureDate;
				}
			}
		}
  }
  //This should not happen, maybe trow an exception here later.
  return habitDate;  //remove later, its here just so I dont get an error while writing 
}

List<int> orderHabitsByCompletion({required List<int> currentList, required DateTime selectedDate}) {
  List<int> myList = currentList;
  myList.sort((int index1, int index2) {
    Habit habit1 = boxHabits.get(index1);
    Habit habit2 = boxHabits.get(index2);

    bool completed1 = habit1.completionDates.containsKey(DateFormat('yyyy.M.d').format(selectedDate));
    bool completed2 = habit2.completionDates.containsKey(DateFormat('yyyy.M.d').format(selectedDate));

    // Put completed habits at the top
    if (completed1 && !completed2) {
      return -1;
    } else if (!completed1 && completed2) {
      return 1;
    } else {
      // Keep the original order for uncompleted habits
      return 0;
    }
  });
  return myList;
}

bool isEarlier(TimeOfDay time1, TimeOfDay time2) {
  DateTime dateTime1 = DateTime(2023, 1, 1, time1.hour, time1.minute);
  DateTime dateTime2 = DateTime(2023, 1, 1, time2.hour, time2.minute);
  return dateTime1.isBefore(dateTime2);
}

List<int> orderHabitsByTime({required List<int> currentList, required DateTime selectedDate}) {
  List<int> myList = currentList;
  myList.sort((int index1, int index2) {
    Habit habit1 = boxHabits.get(index1);
    Habit habit2 = boxHabits.get(index2);

    bool hasTime1 = habit1.time != null;
    bool hasTime2 = habit2.time != null;
    if (hasTime1 && hasTime2){
      List<String> timeParts1 = habit1.time!.split(':');
      List<String> timeParts2 = habit2.time!.split(':');
      TimeOfDay time1 = TimeOfDay(hour: int.parse(timeParts1[0]), minute: int.parse(timeParts1[1]));
      TimeOfDay time2 = TimeOfDay(hour: int.parse(timeParts2[0]), minute: int.parse(timeParts2[1]));
      if (isEarlier(time1, time2)) {
        return -1; 
      }
      else{
        return 1;
      }
    } else if (hasTime1 && !hasTime2) {
      return -1;
    } else if (!hasTime1 && hasTime2) {
      return 1;
    } else {
      return 0;
    }
    
  });
  return myList;
}

List<int> orderHabitsByAlphabet({required List<int> currentList, required DateTime selectedDate}){
  List<int> myList = currentList;
  myList.sort((int index1, int index2) {
    Habit habit1 = boxHabits.get(index1);
    Habit habit2 = boxHabits.get(index2);
    return habit1.name.compareTo(habit2.name);
  });
  return myList;
}

List<int> orderHabitsByDate({required List<int> currentList, required DateTime selectedDate}){
  List<int> myList = currentList;
  myList.sort((int index1, int index2) {
    Habit habit1 = boxHabits.get(index1);
    Habit habit2 = boxHabits.get(index2);
    DateTime habitDate1 = DateTime(habit1.date['year'], habit1.date['month'],habit1.date['day']);
    DateTime habitDate2 = DateTime(habit2.date['year'], habit2.date['month'],habit2.date['day']);
    if(habitDate1.isBefore(habitDate2)){
      return -1;
    } else if(habitDate1.isAfter(habitDate2) || habitDate1.isAtSameMomentAs(habitDate2)){
      return 1;
    } else {
      return 0;
    }
  });
  return myList;
}