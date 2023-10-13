part of 'habit_form_cubit.dart';

class HabitFormState extends Equatable {
  final String? habitName;
  final TimeOfDay? time;
  final bool notify;
  final String recurrenceSet;
  final double? goal;
  final String? unit;
  final DateTime? selectedDate;

  const HabitFormState({
    this.habitName,
    this.time,
    this.notify = false,
    this.recurrenceSet = 'Every Day',
    this.goal,
    this.unit,
    this.selectedDate,
  });

  //the reason why time is managed seperately and not inside copyWith as well, is because I want to be able to set time to null from the UI

  HabitFormState setTime(TimeOfDay? time) {
  return HabitFormState(
    habitName: habitName,
    time: time,                   //this will set the state to the provided value called time and leave everything else the same
    notify: notify,
    recurrenceSet: recurrenceSet,
    goal: goal,
    unit: unit,
    selectedDate: selectedDate,
  );
}
  
  HabitFormState copyWith({
    String? habitName,
    bool? notify,
    String? recurrenceSet = 'Every Day',
    double? goal,
    String? unit,
    DateTime? selectedDate,
  }){
    return HabitFormState(
      habitName: habitName ?? this.habitName,           //if the habitName is provided in copyWith, change it. Else keep it the same  (this.habitName)
      time: time,                                     //this will keep the time always the same when we call copywith - PS:   this.time but 'this' here is unnecessary
      notify: notify ?? this.notify,
      recurrenceSet: recurrenceSet ?? this.recurrenceSet,
      goal: goal ?? this.goal,
      unit: unit ?? this.unit,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [habitName, time, notify, recurrenceSet, goal, unit, selectedDate];
}
/*
class HabitFormWithMeasurement extends HabitFormState {
  final double? goal;
  final String? unit;

  const HabitFormWithMeasurement({
    required String? habitName,
    required TimeOfDay? time,
    required bool notify,
    required String recurrenceSet,
    required this.goal,
    required this.unit,
  }) : super(
          habitName: habitName,
          time: time,
          notify: notify,
          recurrenceSet: recurrenceSet,
        );

  @override
  List<Object?> get props => super.props + [goal, unit];
}
*/
