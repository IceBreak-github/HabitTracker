import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/route_widgets.dart';
import '../pages/newhabit_page.dart';
import '../shared/constants.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HabitSettings extends StatefulWidget {
  const HabitSettings({super.key});

  @override
  State<HabitSettings> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<HabitSettings> {
  String? _groupValue = "Yes or No";
  ValueChanged<String?> _valueChangedHandler() {
    return (value) => setState(() => _groupValue = value!);
  }
  bool trackable = true;
  bool recurrent = true;

  habitType(String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget> [
          InkWell(
              child: Icon(
                icon,
                color: Constants().secondaryColor,
                size: 24.0,
              ),
          ),
          const SizedBox(
            width: 25,
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
          const Spacer(),
          FilledRadioButton<String>(
            value: value,
            groupValue: _groupValue,
            onChanged: _valueChangedHandler(),
          ),
          const SizedBox(
            width: 35,
          ),
        ],
      ),
    );
  }

  habitSetting(bool value, String text, IconData icon){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget> [
          InkWell(
              child: Icon(
                icon,
                color: Constants().secondaryColor,
                size: 24.0,
              ),
          ),
          const SizedBox(
            width: 25,
          ),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
          const Spacer(),
          FlutterSwitch(
            value: value,
            width: 60.0,
            height: 24.0,
            toggleSize: 24,
            padding: 0,
            activeColor: Constants().backgroundColor,
            inactiveColor: Constants().backgroundColor,
            toggleColor: Constants().primaryColor,
            onToggle: (bool valueChange) {
              setState(() {
                text == 'Trackable' ? trackable = valueChange : recurrent = valueChange;             //ugly stuff change later
              });
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        habitType('Measurement', Icons.scale_rounded),
        habitType('Yes or No', Icons.flaky_rounded),
        habitType('Question', Icons.help_rounded),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Divider(
            color: Constants().darkGrey,
          ),
        ),
        habitSetting(trackable, 'Trackable', Icons.query_stats_rounded),
        habitSetting(recurrent, 'Recurrent', Icons.change_circle),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 170,
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants().primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
              onPressed: () {
                nextScreen(context, NewHabitPage(habitType: _groupValue, trackable: trackable, recurrent: recurrent));
              },
              child: const Text("OK", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }
}

class FilledRadioButton<T> extends StatelessWidget {
    final T value;
    final T? groupValue;
    final ValueChanged<T?> onChanged;
    const FilledRadioButton({super.key, required this.value, required this.groupValue, required this.onChanged});

    Widget _buildButton() {
      final bool isSelected = value == groupValue;
      return Container(	
        width: 26,
        height: 26,
        decoration: ShapeDecoration(
          shape: const CircleBorder(
          ),
        color: Constants().backgroundColor
        ),
        child: Center(
          child: Container(
            width: 15,
            height: 15,
            decoration: ShapeDecoration(
              shape: const CircleBorder(
              ),
              color: isSelected ? Constants().primaryColor : Constants().backgroundColor,
            ),
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: _buildButton(),
    );
  }
}

