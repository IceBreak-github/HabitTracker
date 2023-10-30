import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_home_state.dart';

class HabitHomeCubit extends Cubit<HabitHomeState> {
  HabitHomeCubit() : super(HabitHomeState(
    selectedDate: DateTime.now(),
    isChecked: const {}, 
    progressBar: const {'allHabits' : 0, 'countTrueValues': 0, 'ratio': 0.0},
    hasAnyHabits: true,
    measurementValue: 0,
    measurementValues: const {},
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
    final Map<String, dynamic> updatedProgressBar = Map.from(state.progressBar);
    updatedProgressBar['allHabits'] = allHabits;
    updatedProgressBar['countTrueValues'] = countTrueValues;
    updatedProgressBar['ratio'] = ratio;
    emit(state.copyWith(progressBar: updatedProgressBar));
  }

  void setHasAnyHabits(bool value){
    emit(state.copyWith(hasAnyHabits: value));
  }

  void changeMeasurementValue(int value){
    emit(state.copyWith(measurementValue: value));
  }

  void setMeasurementValues(String day, int value){
    final Map<String, int> updatedMeasurementValues = Map.from(state.measurementValues);
    updatedMeasurementValues[day] = value;
    emit(state.copyWith(measurementValues: updatedMeasurementValues));
  }

  void removeMeasurementValues(String keyValue) {
    final Map<String, int> updatedMeasurementValues= Map.from(state.measurementValues);
    updatedMeasurementValues.removeWhere((key, value) => key.startsWith(keyValue));
    emit(state.copyWith(measurementValues: updatedMeasurementValues));
  }

}
