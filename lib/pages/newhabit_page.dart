import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:habit_tracker/pages/today_page.dart';

import '../shared/constants.dart';
import '../widgets/checkbox_widgets.dart';
import '../widgets/route_widgets.dart';

class NewHabitPage extends StatefulWidget {
  final String? habitType;
  final bool trackable;
  final bool recurrent;
  const NewHabitPage({super.key, required this.habitType, required this.trackable, required this.recurrent});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  final formKey = GlobalKey<FormState>();
  TimeOfDay? time;
  bool timeSet = false;
  bool notify = false;
  final shakeTimeKey = GlobalKey<ShakeWidgetState>();

  List<bool> isSelected = [true, false, false];
  String recurrenceSet = 'Every Day';
  	
  Map<String, bool?> weekDays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    var appBar = AppBar( 
      toolbarHeight: 70,
      title: const Text("New Habit", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
      leadingWidth: 70,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: Constants().backgroundColor,
      elevation: 0,
      leading: 
        InkWell(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 26.0,
          ),
          onTap: (){
            nextScreen(context, const TodayPage());
          }
        ),
    );

    inputWidget({required String text, required IconData icon, required double width, required Widget child, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Container(
            width: width,
            height: 51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Constants().widgetColor,
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    icon,
                    color: Constants().secondaryColor,
                    size: 20,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Constants().lightGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child
            ]),
          ),
        ),
      );
    }

    var submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: SizedBox(
        height: 51,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants().primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            onPressed: () {
                print(widget.habitType);
                print(widget.trackable);
                print(widget.recurrent);
            },
            child: const Text("Save Habit", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    textInput({required String placeholder}){
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            cursorColor: Constants().secondaryColor,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: TextStyle(color: Constants().placeHolderColor, fontWeight: FontWeight.w500, fontSize: 14),
            ),
            onChanged: (val) {
              print(val);
            },
          ),
        ),
      );
    }
    
    var timeSelect = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget> [
          SizedBox(
            width: 36,
            child: Text(timeSet ? "${time!.hour.toString()}:${time!.minute.toString()}" : "time", style: TextStyle(color: timeSet ?Colors.white : Constants().placeHolderColor, fontSize: 14, fontWeight: FontWeight.w500))),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              Icons.expand_more_rounded,
              color: Constants().lightGrey,
              size: 32
            ),
          ),
        ]
      ),
    );

    var timeDelete =
      AnimatedOpacity(
        opacity: timeSet ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: (){
            setState((){
              time = null;
              timeSet = false;
              notify = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              height: 51,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Constants().widgetColor,
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
              child: Icon(
                Icons.delete_forever_rounded,
                color: Constants().lightGrey,
                size: 20
              )
            ),
          ),
        ),
      );

    var notifyToggle = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget> [
          SizedBox(
            width: 30,
            child: Text(notify ? "Yes" : "No", style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500))),
          const SizedBox(width: 20),
          FlutterSwitch(
              value: notify,
              width: 60.0,
              height: 24.0,
              toggleSize: 24,
              padding: 0,
              activeColor: Constants().backgroundColor,
              inactiveColor: Constants().backgroundColor,
              toggleColor: Constants().primaryColor,
              onToggle: (bool valueChange) {
                timeSet ? null : shakeTimeKey.currentState?.shake(); 
                setState(() {
                  timeSet ? notify = valueChange : notify = false;             //implement notifications
                });
              }
          ),
        ],
      ),
    );

    recurrencePanel() {
      return showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        backgroundColor: Constants().widgetColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          bool interval = true;
          bool week = false;
          bool month = false;
          String groupValue = recurrenceSet;
          Map<String, bool?> _weekDays = weekDays;

          double? height = 420;

          return StatefulBuilder(
            builder: (BuildContext context, setModalState){

            ValueChanged<String?> valueChangedHandler() {
              return (value) => setModalState(() => groupValue = value!);
            }

              setInterval(String value){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    width: 210,
                    child: Row(
                      children: <Widget> [
                        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                        const Spacer(),
                        FilledRadioButton<String>(
                          value: value,
                          groupValue: groupValue,
                          onChanged: valueChangedHandler(),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                      ],
                    ),
                  ),
                );
              }

              buildWeekList(String day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 150,
                    child: Row(
                      children: <Widget> [
                        Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                        const Spacer(),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _weekDays[day],
                            activeColor: Constants().primaryColor,
                            checkColor: Constants().backgroundColor,
                            /*
                            fillColor: MaterialStateProperty.resolveWith((states){return Constants().backgroundColor;}),
                            checkColor: Constants().primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)),
                            */
                            onChanged: (newBool){
                              setModalState((){
                                _weekDays[day] = newBool;
                              });
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              var intervalPage = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54),
                child: Row(
                  children: [Column(
                    children: <Widget> [
                      setInterval('Every Day'),
                      setInterval('Every 3 Days'),
                      setInterval('Every 2 Weeks'),
                      setInterval('Every 1 Month'),
                    ],
                  ),]
                ),
              );
              
              var weekPage = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54),
                child: Row(
                  children: [
                    Column(
                      children: [
                          const SizedBox(height: 4),
                          for(String day in _weekDays.keys)
                          buildWeekList(day)
                      ],
                    ),
                  ],
                ),
              );
              var monthPage = Container(
                child: const Text('Month Page')
              );
              var recurrencePanel = SizedBox(
                height: height,
                child: Column(
                  children: <Widget> [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13),   
                          child: Container(
                            height: 5,
                            width: 85,
                            decoration: const ShapeDecoration(
                              color: Color.fromRGBO(55,55,82,1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Set Recurrence', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white))
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [                                                                           //TODO: make tha buttons take space from the sides so the navigation is as big as tha divider below
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: SizedBox(
                            height: 31,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: interval ? Constants().secondaryColor : Constants().backgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                onPressed: (){
                                  setModalState((){
                                    interval = true;
                                    week = false;
                                    month = false;
                                    height = 420;
                                  });
                                },
                                child: Text('Interval', style: TextStyle(color: interval ? Colors.black : Constants().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: SizedBox(
                            height: 31,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: week ? Constants().secondaryColor : Constants().backgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                onPressed: (){
                                  setModalState((){
                                    interval = false;
                                    week = true;
                                    month = false;
                                    height = 500;
                                  });
                                },
                                child: Text('Week', style: TextStyle(color: week ? Colors.black : Constants().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: SizedBox(
                            height: 31,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: month ? Constants().secondaryColor : Constants().backgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                onPressed: (){
                                  setModalState((){
                                    interval = false;
                                    week = false;
                                    month = true;
                                  });
                                },
                                child: Text('Month', style: TextStyle(color: month ? Colors.black : Constants().lightGrey, fontSize: 12, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Divider(
                        height: 1,
                        color: Color.fromRGBO(82,82,82,1)
                      ),
                    ),
                    interval ? intervalPage : Container(),
                    week ? weekPage : Container(),
                    month ? monthPage : Container(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Text('SAVE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Constants().primaryColor)),
                            onTap: (){
                              if(interval){
                                print(groupValue);
                                setState((){
                                  recurrenceSet = groupValue;
                                });
                              }
                              if(week){
                                setState((){
                                  recurrenceSet = 'Custom';
                                });
                              }
                              Navigator.pop(context);
                            }
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              );
              return recurrencePanel;
            }
          );
        }
      );
    }

    recurrenceSelect() { 
      String recurrenceTextFull;
      int counter = 9;

      if(recurrenceSet.length <= counter){
        recurrenceTextFull = recurrenceSet.substring(0,recurrenceSet.length);
      }
      else{
        recurrenceTextFull = "${recurrenceSet.substring(0,counter)}...";
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget> [
            SizedBox(
              width: 90,
              child: Text(recurrenceTextFull, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Icon(
                Icons.expand_more_rounded,
                color: Constants().lightGrey,
                size: 32
              ),
            ),
          ]
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Stack(
        children: <Widget> [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25),   
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          inputWidget(text: "Name:", icon: Icons.drive_file_rename_outline_rounded, width: width, child: textInput(placeholder: "e.g. Meditation"), onTap: (){}),
                          Row(
                            children: [
                              ShakeMe(
                                // pass the GlobalKey as an argument
                                key: shakeTimeKey,
                                // configure the animation parameters
                                shakeCount: 3,
                                shakeOffset: 8,
                                shakeDuration: const Duration(milliseconds: 500),
                                // Add the child widget that will be animated
                                child: inputWidget(text: "Time:", icon: Icons.watch_later, width: 230, child: timeSelect, onTap: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(hour: 12, minute: 12),
                                  );
                                  if(newTime != null){
                                    setState(() {
                                      time = newTime;
                                      timeSet = true;
                                      notify = true;
                                    });
                                    print(time);
                                  }
                                }),
                              ),
                              const SizedBox(width: 25),
                              timeDelete,
                            ],
                          ),
                          inputWidget(text: "Notify:", icon: Icons.notifications_active_rounded, width: 270, child: notifyToggle, onTap: (){
                            timeSet ? null : shakeTimeKey.currentState?.shake();       //shake the widget when timeSet is false
                            setState((){
                              timeSet ? notify = !notify : notify = false;         
                            });
                          }),
                          widget.recurrent ? 
                          inputWidget(text: "Recurrence:", icon: Icons.change_circle, width: 310, child: recurrenceSelect(), onTap: (){
                            recurrencePanel();
                          }) : Container()
                        ],     
                      ), 
                    ),
                  ),
                ),
              ),
            ),
            submitButton
          ]
          ),
        ],
      ),
    );
  }
}


