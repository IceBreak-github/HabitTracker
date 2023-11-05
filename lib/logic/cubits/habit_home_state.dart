part of 'habit_home_cubit.dart';

class HabitHomeState extends Equatable {
  final DateTime? selectedDate;
  final Map<String, bool> isChecked;
  final Map<String, dynamic> progressBar;
  final int measureNumber;
  final Map<String, int> measurementValues;
  final List<int> shownHabitIndexes;
  const HabitHomeState({
    this.selectedDate,
    this.isChecked = const {},
    this.progressBar = const {'allHabits' : 0, 'countTrueValues': 0, 'ratio': 0.0},
    this.measureNumber = 0,
    this.measurementValues = const {},
    this.shownHabitIndexes = const [],
  });

  HabitHomeState copyWith({
    DateTime? selectedDate,
    Map<String, bool>? isChecked,    
    Map<String, dynamic>? progressBar,
    int? measureNumber,
    Map<String, int>? measurementValues,
    List<int>? shownHabitIndexes,
  }) {
    return HabitHomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      isChecked: isChecked ?? this.isChecked,           //if the habitName is provided in copyWith, change it. Else keep it the same  (this.habitName)
      progressBar: progressBar ?? this.progressBar,
      measureNumber: measureNumber ?? this.measureNumber,
      measurementValues: measurementValues ?? this.measurementValues,
      shownHabitIndexes: shownHabitIndexes ?? this.shownHabitIndexes,
    );
  }

  @override
  List<Object?> get props => [selectedDate, isChecked, measureNumber, measurementValues, progressBar, shownHabitIndexes];
}
