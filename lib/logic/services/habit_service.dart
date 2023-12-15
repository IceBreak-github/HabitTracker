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