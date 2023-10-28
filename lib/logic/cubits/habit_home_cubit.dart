import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_home_state.dart';

class HabitHomeCubit extends Cubit<HabitHomeState> {
  HabitHomeCubit() : super(HabitHomeState(
    selectedDate: DateTime.now(),
    isChecked: const {}, 
    ratio: 0, 
    hasAnyHabits: true,
  ));

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setCheckValue(String day, bool value){
    final Map<String, bool> updatedIsChecked = Map.from(state.isChecked);
    updatedIsChecked[day] = value;
    emit(state.copyWith(isChecked: updatedIsChecked));
  }

  void removeCheckValue(String keyValue) {
    final Map<String, bool> updatedIsChecked = Map.from(state.isChecked);
    updatedIsChecked.removeWhere((key, value) => key.startsWith(keyValue));
    emit(state.copyWith(isChecked: updatedIsChecked));
  }

  void updateValues(int allHabits, int countTrueValues, double ratio) {
    emit(state.copyWith(allHabits: allHabits, countTrueValues: countTrueValues, ratio: ratio));
  }

  void setHasAnyHabits(bool value){
    emit(state.copyWith(hasAnyHabits: value));
  }

}
