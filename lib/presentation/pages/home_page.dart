import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';
import 'package:habit_tracker/shared/boxes.dart';

import '../../shared/colors.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: <Widget> [
          //TODO: This is where the individuals habits will be shown
          ListView.builder(
            itemCount: boxHabits.length,
            itemBuilder: (context, index) {
              Habit habit = boxHabits.getAt(index);
              print(habit.habitType);
              print(habit.name);
              print(habit.time);
              print(habit.notify);
              print(habit.recurrence);
              return ListTile(
                title: Text(habit.name, style: const TextStyle(color: Colors.white)),
              );
            }
          ),
          TextButton.icon(                                      //TODO: Remove later, this is here only for testing
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete all'),
            onPressed: () {
              boxHabits.clear();
            }
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(9),
        child: SizedBox(
          height: 60,   //50
          width: 60,      //50
          child: FloatingActionButton(
            onPressed: (){
              //TODO: Implement add habit
               createHabitPopUp(context);
            },
            //elevation: 0,
            backgroundColor: MyColors().primaryColor,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.black,
              size: 50,   //40
            ),
          )),
      ),
      drawer: const Drawer(),
    );
  }
}