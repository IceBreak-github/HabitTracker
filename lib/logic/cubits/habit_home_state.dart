part of 'habit_home_cubit.dart';

class HabitHomeState extends Equatable {
  final DateTime? selectedDate;
  final Map<String, bool> isChecked;
  final int? allHabits;
  final int? countTrueValues;
  final double ratio;
  final bool hasAnyHabits;
  const HabitHomeState({
    this.selectedDate,
    this.isChecked = const {},
    this.allHabits,
    this.countTrueValues,
    this.ratio = 0,
    this.hasAnyHabits = true,
  });

  HabitHomeState copyWith({
    DateTime? selectedDate,
    Map<String, bool>? isChecked,    
    int? allHabits,
    int? countTrueValues,
    double? ratio,
    bool? hasAnyHabits,
  }) {
    return HabitHomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      isChecked: isChecked ?? this.isChecked,           //if the habitName is provided in copyWith, change it. Else keep it the same  (this.habitName)
      allHabits: allHabits ?? this.allHabits,
      countTrueValues: countTrueValues ?? this.countTrueValues,
      ratio: ratio ?? this.ratio,
      hasAnyHabits: hasAnyHabits ?? this.hasAnyHabits,
    );
  }

  @override
  List<Object?> get props => [selectedDate, isChecked, allHabits, countTrueValues, ratio, hasAnyHabits];
}
