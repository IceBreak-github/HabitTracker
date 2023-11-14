import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'habit_form_state.dart';

class HabitFormCubit extends Cubit<HabitFormState> {
  final String? habitName;
  final TimeOfDay? time;
  final bool? notify;
  final String? recurrenceSet;
  final int? goal;
  final String? unit;
  final DateTime? selectedDate;
  HabitFormCubit({this.habitName, this.time, this.notify, this.recurrenceSet, this.goal, this.unit, this.selectedDate}) 
  : super(HabitFormState(
    habitName: habitName,
    time: time,
    notify: notify ?? false,
    recurrenceSet: recurrenceSet ?? 'Every Day',
    goal: goal,
    unit: unit,
    selectedDate: selectedDate ?? DateTime.now(),
  ));

  void setHabitName(String value) {
    emit(state.copyWith(habitName: value));
  }

  void setHabitTime(TimeOfDay? value) {
    emit(state.setTime(value));
  }

  void toggleHabitNotify(bool value) {
    emit(state.copyWith(notify: value));
  }

  void setHabitGoal(int value) {
    emit(state.copyWith(goal: value));
  }

  void setHabitGoalUnit(String value) {
    emit(state.copyWith(unit: value));
  }

  void setHabitDate(DateTime value){
    emit(state.copyWith(selectedDate: value));
  }

  void setHabitRecurrence(String value){
    emit(state.copyWith(recurrenceSet: value));
  }
}
