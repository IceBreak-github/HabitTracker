import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_home_cubit.dart';
import 'package:habit_tracker/shared/colors.dart';

class FilledRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  const FilledRadioButton(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged});

  Widget _buildButton() {
    final bool isSelected = value == groupValue;
    return Container(
      width: 26,
      height: 26,
      decoration: ShapeDecoration(
          shape: const CircleBorder(), color: MyColors().backgroundColor),
      child: Center(
        child: Container(
          width: 15,
          height: 15,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: isSelected
                ? MyColors().primaryColor
                : MyColors().backgroundColor,
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

class CustomCheckbox extends StatelessWidget {
  final VoidCallback onChanged;
  final String name;
  final String date;

  const CustomCheckbox({
    Key? key,
    required this.onChanged,
    required this.name,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitHomeCubit, HabitHomeState>(
      builder: (context, habitCheckState) {
        bool checked = habitCheckState.isChecked["${date}_$name"] ?? false;
        return InkWell(
          onTap: () {
            onChanged();
          },
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors().backgroundColor,
              shape: BoxShape.circle,
            ),
            child: checked
                ? Transform.scale(
                    scale: 1.15, // Adjust the scale factor as needed
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(Icons.task_alt,
                          color: MyColors().primaryColor, size: 30.0),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
