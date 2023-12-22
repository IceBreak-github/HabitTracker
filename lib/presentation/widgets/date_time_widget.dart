// Copied and edited date_time_line 0.0.3

library date_time_line;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:intl/intl.dart';

import '../../shared/colors.dart';

typedef Callback = void Function(DateTime val);

List dateGenerator(DateTime date) {
  List dates = [];
  for (var i = 15; i >= 0; i--) {
    dates.add(date.subtract(Duration(days: i)));
  }
  for (var i = 1; i <= 15; i++) {
    dates.add(date.add(Duration(days: i)));
  }
  return dates;
}


class DateTimeLine extends StatelessWidget {
  final double width;
  final Color color;
  final Callback onSelected;
  const DateTimeLine({
    super.key,
    required this.width,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {  
    return BlocBuilder<HabitHomeCubit, HabitHomeState>(
      builder: (context, state) {
        List dates = dateGenerator(state.selectedDate!);
        late ScrollController scrollController;
        scrollController = ScrollController(
          initialScrollOffset: 845 - (width - 213) * 0.49,
          keepScrollOffset: true,
        );
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 57,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior()
                    .copyWith(overscroll: false), //disables scroll glow
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      bool isSelected = DateTime(dates[index].year, dates[index].month, dates[index].day) == DateTime(state.selectedDate!.year, state.selectedDate!.month, state.selectedDate!.day) ? true : false;
                      final DateFormat dayFormatter = DateFormat('E');
                      final String day = dayFormatter.format(dates[index]);
                      final DateFormat dateFormatter = DateFormat('d');
                      final String date = dateFormatter.format(dates[index]);
                      return Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: GestureDetector(
                          onTap: () {
                            onSelected(dates[index]);
                            scrollController.animateTo(
                                845 - (MediaQuery.of(context).size.width - 213) * 0.49,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease);
                            dates = dateGenerator(state.selectedDate!);
                          },
                          child: Container(
                            width: 47,
                            decoration: BoxDecoration(
                                color: MyColors().widgetColor,
                                borderRadius: BorderRadius.circular(10),
                                border: (!isSelected &&
                                        DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()) ==
                                            DateFormat('EEEE, d MMM, yyyy').format(dates[index]))
                                    ? Border.all(color: MyColors().secondaryColor, width: 1)
                                    : null),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0, bottom: 7),
                                  child: Text(
                                    day.substring(0, 2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: MyColors().lightGrey,
                                        fontSize: 10),
                                  ),
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: !isSelected ? MyColors().lightGrey : Colors.white,
                                      fontSize: 14),
                                ),
                                const Spacer(),
                                Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: !isSelected ? Colors.transparent : color,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      },
    );
  }
}