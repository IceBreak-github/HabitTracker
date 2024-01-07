import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/settings_model.dart';
import 'package:habit_tracker/shared/boxes.dart';

part 'habit_settings_state.dart';

class HabitSettingsCubit extends Cubit<HabitSettingsState> {
  HabitSettingsCubit() : super(HabitSettingsState(
    notifications: boxSettings.get(0).notifications,
    vibrations: boxSettings.get(0).vibrations,
    orderHabits: boxSettings.get(0).orderHabits,
    setWidget: boxSettings.get(0).setWidget,
    theme: boxSettings.get(0).theme,
    primaryColor: Color(int.parse(boxSettings.get(0).primaryColor, radix: 16)),
    secondaryColor: Color(int.parse(boxSettings.get(0).secondaryColor, radix: 16)),
    backgroundColor: Color(int.parse(boxSettings.get(0).backgroundColor, radix: 16)),
    widgetColor: Color(int.parse(boxSettings.get(0).widgetColor, radix: 16)),
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

  void restoreSettings() {
    boxSettings.put(0, Settings(          //restore the box
      vibrations: true,
      notifications: true,
      orderHabits: 'Automat. ',
      setWidget: false,
      theme: 'Dark',
      primaryColor: 'ff00ffc1',
      secondaryColor: 'ff90ffe4',
      backgroundColor: 'ff121219',
      widgetColor: 'ff22222d',
    ));
    toggleVibrations(true);               //restore the state
    toggleNotifications(true);
    setHabitOrder('Automat.');
    toggleWidget(false);
    setTheme('Dark');
    setPrimaryColor(const Color.fromRGBO(0,255,193,1));
    setSecondaryColor(const Color.fromRGBO(144, 255, 228, 1));
    setBackgroundColor(const Color.fromRGBO(18,18,25,1));
    setWidgetColor(const Color.fromRGBO(34,34,45,1));

    //TODO revert changes
  }

}
