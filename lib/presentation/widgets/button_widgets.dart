import 'package:flutter/material.dart';
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