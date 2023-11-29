import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/widgets/statistics_page_widgets.dart';
import 'package:habit_tracker/shared/boxes.dart';
import 'package:habit_tracker/shared/colors.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StatisticsAppBar(),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              const OverallScore(),
              const StatsDivider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, left: 25,right: 25),
                  child: ScrollConfiguration(
                  behavior: const ScrollBehavior()
                  .copyWith(overscroll: false), 
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 55),
                      itemCount: boxHabits.length,
                      itemBuilder: (context, index) {
                        Habit habit = boxHabits.getAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 186,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyColors().widgetColor,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.10),
                                    blurRadius:
                                        4.0, // soften the shadow
                                    spreadRadius:
                                        4.0, //extend the shadow
                                    offset: const Offset(
                                      2.0, // Move to right 5  horizontally
                                      5.0, // Move to bottom 5 Vertically
                                    ),
                                  ),
                                ],
                              ),
                            child: HabitStatPanel(habit: habit)
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}