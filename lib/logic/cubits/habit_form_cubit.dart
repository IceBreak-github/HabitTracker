import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'habit_form_state.dart';

class HabitFormCubit extends Cubit<HabitFormState> {
  HabitFormCubit() : super(HabitFormState(
    habitName: null,
    time: null,
    notify: false,
    recurrenceSet: 'Every Day',
    goal: null,
    unit: null,
    selectedDate: DateTime.now(),
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

  void setHabitGoal(double value) {
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
