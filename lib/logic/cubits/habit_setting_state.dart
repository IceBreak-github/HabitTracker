part of 'habit_setting_cubit.dart';

class HabitSettingState extends Equatable {
  final bool trackable;
  final bool recurrent;
  final String habitType;

  const HabitSettingState({required this.trackable, required this.recurrent, required this.habitType});

  @override
  List<Object> get props => [trackable, recurrent, habitType];

   HabitSettingState copyWith({
    bool? trackable,
    bool? recurrent,
    String? habitType,
  }) {
    return HabitSettingState(
      trackable: trackable ?? this.trackable,
      recurrent: recurrent ?? this.recurrent,
      habitType: habitType ?? this.habitType,
    );
  }
}

