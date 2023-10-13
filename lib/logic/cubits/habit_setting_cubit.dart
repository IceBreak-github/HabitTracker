import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_setting_state.dart';

class HabitSettingCubit extends Cubit<HabitSettingState> {
  HabitSettingCubit()
      : super(const HabitSettingState(
          trackable: true,
          recurrent: true,
          habitType: "Yes or No",
        ));

  void updateSettings({bool? trackable, bool? recurrent}) {
    emit(state.copyWith(trackable: trackable, recurrent: recurrent));
  }

  void updateHabitType(String value) {
    emit(state.copyWith(habitType: value));
  }
}


