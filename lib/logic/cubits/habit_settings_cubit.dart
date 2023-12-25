import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_settings_state.dart';

class HabitSettingsCubit extends Cubit<HabitSettingsState> {
  HabitSettingsCubit() : super(const HabitSettingsState(
    notifications: true,
    vibrations: true,
    orderHabits: 'Automat.',
    setWidget: false,
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

}
