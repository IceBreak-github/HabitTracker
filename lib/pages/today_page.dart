import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/checkbox_widgets.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar( 
        toolbarHeight: 70,
        title: const Text("Today", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
        leadingWidth: 70,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Constants().backgroundColor,
        elevation: 0,
        actions: [
        Row(
          children: <Widget> [
            IconButton(onPressed: () {
              //TODO: Implement search 
              },
              icon: const Icon(Icons.search_rounded), 
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9),
                  child: IconButton(onPressed: () {
                //TODO: Implement filter 
                },
                icon: const Icon(Icons.filter_list_rounded), 
              ),
            ),
          ]
        ),
      ],
    );
    


    createHabitPopUp(BuildContext context) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a Habit", 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            backgroundColor: Constants().widgetColor,
            titlePadding: const EdgeInsets.only(top:40),
            insetPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.only(top:15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: 
              Builder(
                builder: (context) {                           
                  var width = MediaQuery.of(context).size.width;
                  return SizedBox(
                    height: 400,
                    width: width - 50,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: HabitSettings(),
                    ),
                  );
                },
              ),
            
            
          );
        }
      );
    }

    return Scaffold(
      appBar: appBar,
      body: const Stack(
        children: <Widget> [

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
            backgroundColor: Constants().primaryColor,
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