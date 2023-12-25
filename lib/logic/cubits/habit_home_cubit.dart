import 'package:bloc/bloc.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/logic/services/habit_service.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:intl/intl.dart';

part 'habit_home_state.dart';

class HabitHomeCubit extends Cubit<HabitHomeState> {
  HabitHomeCubit() : super(HabitHomeState(
    selectedDate: DateTime.now(),
    isChecked: const {}, 
    progressBar: const {'allHabits' : 0, 'countTrueValues': 0, 'ratio': 0.0},
    measureNumber: 0,
    measurementValues: const {},
    shownHabitIndexes: const [],
    isSearched: false,
    searchHabitIndexes: const [],
  )){
    updateProgressBar();        //Fixes flickering
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setCheckValue(String day, bool value){
    final Map<String, bool> updatedIsChecked = Map.from(state.isChecked);
    updatedIsChecked[day] = value;
    emit(state.copyWith(isChecked: updatedIsChecked));
  }

  void updateProgressBar() {
    final Map<String, dynamic> updatedProgressBar = Map.from(state.progressBar);
    int allHabits = state.isChecked.length;
    int countTrueValues = state.isChecked.values.where((value) => value == true).length;
    double ratio = allHabits != 0 ? countTrueValues / allHabits : 0.0;  //because we cant devide with zero
    updatedProgressBar['allHabits'] = allHabits;
    updatedProgressBar['countTrueValues'] = countTrueValues;
    updatedProgressBar['ratio'] = ratio;
    emit(state.copyWith(progressBar: updatedProgressBar));
  }

  void changeMeasurementValue(int value){
    emit(state.copyWith(measureNumber: value));
  }

  void setMeasurementValues(String day, int value){
    final Map<String, int> updatedMeasurementValues = Map.from(state.measurementValues);
    updatedMeasurementValues[day] = value;
    emit(state.copyWith(measurementValues: updatedMeasurementValues));
  }

  void cleanHomeCubit(String keyValue){
    final Map<String, bool> updatedIsChecked = Map.from(state.isChecked);
    final Map<String, int> updatedMeasurementValues= Map.from(state.measurementValues);
    updatedIsChecked.removeWhere((key, value) => key.startsWith(keyValue));
    updatedMeasurementValues.removeWhere((key, value) => key.startsWith(keyValue));
    emit(state.copyWith(measurementValues: updatedMeasurementValues, isChecked: updatedIsChecked));
  }

  void handleSelectedDateChange(DateTime newDate) {
    final List<int> updatedShownHabitIndexes = [];
    DateTime? currentDate = state.selectedDate;
    String formatedCurrentDate = DateFormat('yyyy.MM.d').format(currentDate!);   
    for (int index = 0; index < boxHabits.length; index++) {
      Habit habit = boxHabits.getAt(index);
      bool show = showHabitOrNot(recurrence: habit.recurrence, habitDate: habit.date, newDate: newDate);
      // Logic to determine if the habit has been checked off
      if (habit.completionDates.containsKey(formatedCurrentDate) && show == true) {
        setCheckValue(
            "${formatedCurrentDate}_${habit.name}", true
        ); // updates UI
      }
      if (!habit.completionDates.containsKey(formatedCurrentDate) && show == true) {
        setCheckValue("${formatedCurrentDate}_${habit.name}",false); //TODO: if two habits have the same name, bad stuff will happen
      }
 
      updateProgressBar();           //updates the progress Bar
      show ? updatedShownHabitIndexes.add(habit.key) : null;              //adds the habit into a list for ListView.builder in the UI
    }
    emit(state.copyWith(shownHabitIndexes: updatedShownHabitIndexes));      //emits the state
  }

  void handleSearch(List<int> habitIndexes) {
    emit(state.copyWith(searchHabitIndexes: habitIndexes));
  }

  void handleReOrder(List<int> habitIndexes) {
    emit(state.copyWith(shownHabitIndexes: habitIndexes));
  }

  void setSearch(bool value) {
    emit(state.copyWith(isSearched: value));
  }

}
