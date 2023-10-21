import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_select_cubit_state.dart';

class DateSelectCubit extends Cubit<DateSelectState> {
  DateSelectCubit() : super(DateSelectState(
    selectedDate: DateTime.now()
  ));

void selectDate(DateTime date) {
  emit(DateSelectState(selectedDate: date));
}

}
