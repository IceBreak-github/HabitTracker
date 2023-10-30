part of 'habit_home_cubit.dart';

class HabitHomeState extends Equatable {
  final DateTime? selectedDate;
  final Map<String, bool> isChecked;
  final Map<String, dynamic> progressBar;
  final bool hasAnyHabits;
  final int measurementValue;
  final Map<String, int> measurementValues;
  const HabitHomeState({
    this.selectedDate,
    this.isChecked = const {},
    this.progressBar = const {'allHabits' : 0, 'countTrueValues': 0, 'ratio': 0.0},
    this.hasAnyHabits = true,
    this.measurementValue = 0,
    this.measurementValues = const {},
  });

  HabitHomeState copyWith({
    DateTime? selectedDate,
    Map<String, bool>? isChecked,    
    Map<String, dynamic>? progressBar,
    bool? hasAnyHabits,
    int? measurementValue,
    Map<String, int>? measurementValues,
  }) {
    return HabitHomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      isChecked: isChecked ?? this.isChecked,           //if the habitName is provided in copyWith, change it. Else keep it the same  (this.habitName)
      progressBar: progressBar ?? this.progressBar,
      hasAnyHabits: hasAnyHabits ?? this.hasAnyHabits,
      measurementValue: measurementValue ?? this.measurementValue,
      measurementValues: measurementValues ?? this.measurementValues
    );
  }

  @override
  List<Object?> get props => [selectedDate, isChecked, hasAnyHabits, measurementValue, measurementValues, progressBar];
}
