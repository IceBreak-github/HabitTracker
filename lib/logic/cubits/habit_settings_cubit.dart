import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/shared/colors.dart';

part 'habit_settings_state.dart';

class HabitSettingsCubit extends Cubit<HabitSettingsState> {
  HabitSettingsCubit() : super(HabitSettingsState(
    notifications: true,
    vibrations: true,
    orderHabits: 'Automat.',
    setWidget: false,
    theme: 'Dark',
    primaryColor: MyColors().primaryColor,
    secondaryColor: MyColors().secondaryColor,
    backgroundColor: MyColors().backgroundColor,
    widgetColor: MyColors().widgetColor,
  ));

  void toggleNotifications(bool value) {
    emit(state.copyWith(notifications: value));
  }

  void toggleVibrations(bool value) {
    emit(state.copyWith(vibrations: value));
  }

  void setHabitOrder(String value){
    emit(state.copyWith(orderHabits: value));
  }

  void toggleWidget(bool value){
    emit(state.copyWith(setWidget: value));
  }

  void setTheme(String value){
    emit(state.copyWith(theme: value));
  }

  void setPrimaryColor(Color color){
    emit(state.copyWith(primaryColor: color));
  }

  void setSecondaryColor(Color color){
    emit(state.copyWith(secondaryColor: color));
  }

  void setBackgroundColor(Color color){
    emit(state.copyWith(backgroundColor: color));
  }

  void setWidgetColor(Color color){
    emit(state.copyWith(widgetColor: color));
  }

}
