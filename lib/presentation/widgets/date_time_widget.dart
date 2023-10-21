
// Copied and edited date_time_line 0.0.3
// TODO: Maybe rewrite to Bloc later

library date_time_line;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/colors.dart';

typedef Callback = void Function(DateTime val);

class DateTimeLine extends StatefulWidget {
  final double width;
  final Color color;
  final String hintText;
  final Callback onSelected;
  const DateTimeLine(
      {Key? key,
      required this.width,
      required this.color,
      required this.onSelected,
      required this.hintText})
      : super(key: key);

  @override
  State<DateTimeLine> createState() => _DateTimeLineState();
}

class _DateTimeLineState extends State<DateTimeLine> {
  String hintText = '';
  List dates = [];
  List monthYear = [];
  DateTime selectedDate = DateTime.now();
  Color color = const Color.fromARGB(255, 135, 194, 99);
  late ScrollController scrollController;

  dateGenerator(DateTime date) {
    setState(() {
      dates = [];
      for (var i = 15; i >= 0; i--) {
        dates.add(date.subtract(Duration(days: i)));
      }
      for (var i = 1; i <= 15; i++) {
        dates.add(date.add(Duration(days: i)));
      }
    });
  }

  scrollPicker(DateTime dateTime) {
    late bool isSelected;

    dateTime == selectedDate ? isSelected = true : isSelected = false;

    final DateFormat dayFormatter = DateFormat('E');
    final String day = dayFormatter.format(dateTime);

    final DateFormat dateFormatter = DateFormat('d');
    final String date = dateFormatter.format(dateTime);

    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDate = dateTime;
            widget.onSelected(dateTime);
            scrollController.animateTo(
                845 - (MediaQuery.of(context).size.width - 213) * 0.49,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease);
            isSelected = false;
            dateGenerator(selectedDate);
          });
        },
        child: Container(
          width: 47,
          decoration: BoxDecoration(
              color: MyColors().widgetColor,
              borderRadius: BorderRadius.circular(10),
              border: (!isSelected && DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()) == DateFormat('EEEE, d MMM, yyyy').format(dateTime)) ? Border.all(color: MyColors().secondaryColor, width: 1) : null
              ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 7),
                child: Text(
                  day.substring(0,2),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: MyColors().lightGrey,
                    fontSize: 10
                  ),
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
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController(
      initialScrollOffset: 845 - (widget.width - 213) * 0.49,
      keepScrollOffset: true,
    );
    color = widget.color;
    hintText = widget.hintText;
    dateGenerator(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 57,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false), //disables scroll glow
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  return Container(child: scrollPicker(dates[index]));
                }),
          ),
        ),
      ],
    );
  }
}
