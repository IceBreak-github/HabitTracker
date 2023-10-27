import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_check_state.dart';

class HabitCheckCubit extends Cubit<HabitCheckState> {
  HabitCheckCubit() : super(const HabitCheckState(
    isChecked: {},
  ));

  void setCheckValue(String day, bool value){
    final Map<String, bool> updatedIsChecked = Map.from(state.isChecked);
    updatedIsChecked[day] = value;
    emit(state.copyWith(isChecked: updatedIsChecked));
  }
}

//Seperating the state management from the data model. I dunno if this is the best approach, it also requires me to sync isChecked with completionDates