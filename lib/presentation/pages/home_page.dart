import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/boxes.dart';

import '../../shared/colors.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: <Widget>[
          //TODO: This is where the individuals habits will be shown
          //TODO: add progress bar
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 23),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior()
                  .copyWith(overscroll: false), //disables scroll glow
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: const Alignment(0.0, 0.53),
                    end: const Alignment(0.0, 1.0),
                    colors: [ Colors.transparent, MyColors().backgroundColor.withOpacity(0.9), MyColors().backgroundColor],
                    //set stops as par your requirement
                    stops: const [0.0,0.5 ,0.9], // 50% transparent, 50% white
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView.builder(
                    itemCount: boxHabits.length,
                    itemBuilder: (context, index) {
                      Habit habit = boxHabits.getAt(index);
                      double height = 51;
                      if (habit.time != null ||
                          habit.habitType == 'Measurement') {
                        height = 107;
                        if (habit.time != null &&
                            habit.habitType == 'Measurement') {
                          height = 145;
                        }
                      }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyColors().widgetColor,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 4.0, // soften the shadow
                                    spreadRadius: 4.0, //extend the shadow
                                    offset: const Offset(
                                      2.0, // Move to right 5  horizontally
                                      5.0, // Move to bottom 5 Vertically
                                    ),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top:
                                        height == 107 || height == 145 ? 24 : 15),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          habit.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 20),
                                          child: (habit.habitType == 'Yes or No')
                                              ? SizedBox(
                                                  width: 21,
                                                  height: 21,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                        () {}, //TODO: create habit completion
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      backgroundColor: MyColors()
                                                          .backgroundColor,
                                                      elevation: 0,
                                                      shape: const CircleBorder(),
                                                    ),
                                                    child: null,
                                                  ))
                                              : SizedBox(
                                                  width: 40,
                                                  height: 26,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                        () {}, //TODO: create habit completion
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      backgroundColor: MyColors()
                                                          .backgroundColor,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                    ),
                                                    child: Text('0',
                                                        style: TextStyle(
                                                            color: MyColors()
                                                                .lightGrey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12)),
                                                  ))),
                                    ],
                                  ),
                                  (habit.time != null)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18, left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.watch_later,
                                                color: MyColors().secondaryColor,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 10),
                                              Text('Time:',
                                                  style: TextStyle(
                                                      color: MyColors().lightGrey,
                                                      fontSize: 12)),
                                              const SizedBox(width: 10),
                                              Text(habit.time!,
                                                  style: TextStyle(
                                                      color:
                                                          MyColors().primaryColor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  (habit.goal != null)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18, left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.stars,
                                                color: MyColors().secondaryColor,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 10),
                                              Text('Goal:',
                                                  style: TextStyle(
                                                      color: MyColors().lightGrey,
                                                      fontSize: 12)),
                                              const SizedBox(width: 10),
                                              Text("${habit.goal}  ${habit.unit}",
                                                  style: TextStyle(
                                                      color:
                                                          MyColors().primaryColor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ]),
                              ),
                            ),
                          );
                        },
                      
                  ),
              ),
            ),
          ),
          
          Positioned(
            bottom: 24,
            left: 0,
            child: 
            DateTimeLine(
              width: MediaQuery.of(context).size.width,
              color: MyColors().primaryColor,
              hintText: "",
              onSelected: (value) {
                print(value);
              },
          ),
          ),
          
          
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 9, bottom: 90),
        child: SizedBox(
            height: 60, //50
            width: 60, //50
            child: FloatingActionButton(
              onPressed: () {
                //TODO: Implement add habit
                createHabitPopUp(context);
              },
              //elevation: 0,
              backgroundColor: MyColors().primaryColor,
              child: const Icon(
                Icons.add_rounded,
                color: Colors.black,
                size: 50, //40
              ),
            )),
      ),
      drawer: const Drawer(),
    );
  }
}
