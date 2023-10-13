import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_recurrence_state.dart';

class HabitRecurrenceCubit extends Cubit<HabitRecurrenceState> {
  HabitRecurrenceCubit() : super(const HabitRecurrenceState(
    recurrenceValue: 'Every Day',
    weekDays: {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': true,
      },
    monthDays: {1: true},
    pages: {'interval': true, 'week': false, 'month' : false},
  ));
  
  void setWeekDayValue(String day, bool value){
    final Map<String, bool> updatedWeekDays = Map.from(state.weekDays);
    updatedWeekDays[day] = value;
    emit(state.copyWith(weekDays: updatedWeekDays));
  }

  void monthDaysRemove(int value) {
    final Map<int, bool> updatedMonthDays = Map.from(state.monthDays);
    updatedMonthDays.remove(value);
    emit(state.copyWith(monthDays: updatedMonthDays));
  }

  void monthDaysAdd(int value) {
    final Map<int, bool> updatedMonthDays = Map.from(state.monthDays);
    updatedMonthDays.addEntries([MapEntry(value, true)]);
    emit(state.copyWith(monthDays: updatedMonthDays));
  }

  void selectPage(String selectedPage) {
    final Map<String, bool> updatedPages = Map.from(state.pages);
    updatedPages.forEach((key, value) {
      if (key != selectedPage) {
        updatedPages[key] = false;
      }
    });
    updatedPages[selectedPage] = true;
    emit(state.copyWith(pages: updatedPages));
  }

 void setWeekDays(Map<String, bool> savedState) {                          
  emit(state.copyWith(weekDays: savedState));
}

void setMonthDays(Map<int, bool> savedState) {
  emit(state.copyWith(monthDays: savedState));
}

void setPages(Map<String, bool> savedState) {
  emit(state.copyWith(pages: savedState));
}

void setRecurrenceValue(String value){
  emit(state.copyWith(recurrenceValue: value));
}
  
}
