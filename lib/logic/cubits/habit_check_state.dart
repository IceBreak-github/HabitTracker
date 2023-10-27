part of 'habit_check_cubit.dart';

class HabitCheckState extends Equatable {
  final Map<String, bool> isChecked;
  const HabitCheckState({
    this.isChecked = const {},
  });

  HabitCheckState copyWith({
    Map<String, bool>? isChecked,
  }){
    return HabitCheckState(
      isChecked: isChecked ?? this.isChecked,           //if the habitName is provided in copyWith, change it. Else keep it the same  (this.habitName)
    );
  }

  @override
  List<Object?> get props => [isChecked];
}
