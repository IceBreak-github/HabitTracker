import 'package:habit_tracker/data/models/habit_model.dart';
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
      DateTime nearestDate = currentDate.add(Duration(days: habitDate.difference(currentDate).inDays % gap));
      print('going to $nearestDate');
      return nearestDate;
    }
		else {
			int counter = habit.recurrence.containsKey('Monday') ? 7 : 31;  //if the recurrence is weekly, do 7, else its monthly - do 31 iterations
			for(int i = 0; i < counter; i++){
				DateTime futureDate = currentDate.add(Duration(days: i));
				if(showHabitOrNot(recurrence: habit.recurrence, habitDate: habit.date, newDate: futureDate)){
					return futureDate;
				}
			}
		}
  }
  return habit.date;  //remove later, its here just so I dont get an error while writing 
}