part of 'date_select_cubit_cubit.dart';

class DateSelectState extends Equatable {
  final DateTime? selectedDate;
  const DateSelectState({
    this.selectedDate,
  });

  @override
  List<Object?> get props => [selectedDate];
}
