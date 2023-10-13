part of 'habit_recurrence_cubit.dart';

class HabitRecurrenceState extends Equatable {
  final String recurrenceValue;
  final Map<String, bool> weekDays;
  final Map<int, bool> monthDays;
  final Map<String, bool> pages;

  const HabitRecurrenceState({
    this.recurrenceValue = 'Every Day',
    this.weekDays = const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': true,
      },
    this.monthDays = const {1: true},
    this.pages = const {'interval': true, 'week': false, 'month' : false},
  });

  HabitRecurrenceState copyWith({
    String? recurrenceValue,
    Map<String, bool>? weekDays,
    Map<int, bool>? monthDays,
    Map<String, bool>? pages,
  }) {
    return HabitRecurrenceState(
      recurrenceValue: recurrenceValue ?? this.recurrenceValue,
      weekDays: weekDays ?? this.weekDays,
      monthDays: monthDays ?? this.monthDays,
      pages: pages ?? this.pages,
    );
  }
        
  @override
  List<Object?> get props => [recurrenceValue, weekDays, monthDays, pages];
}
