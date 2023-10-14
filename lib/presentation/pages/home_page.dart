import 'package:flutter/material.dart';
import 'package:habit_tracker/presentation/widgets/create_habit_popup_widget.dart';

import '../../shared/colors.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: const Stack(
        children: <Widget> [
          //TODO: This is where the individuals habits will be shown
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