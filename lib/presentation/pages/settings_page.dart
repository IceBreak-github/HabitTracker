import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/presentation/widgets/settings_widget.dart';
import 'package:habit_tracker/presentation/widgets/widgets.dart';
import 'package:habit_tracker/shared/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: Stack(
        children: <Widget> [
          GestureDetector(
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
                      InputWidget(
                        text: 'Vibrations:',
                        icon: Icons.edgesensor_high_rounded,
                        width: 293,
                        child: const ToggleVibrations(),
                        onTap: () {
                          context.read<HabitSettingsCubit>().toggleVibrations(!context.read<HabitSettingsCubit>().state.vibrations);
                        },
                      ),
                      InputWidget(
                        text: 'Notifications:',
                        icon: Icons.notifications_active_rounded,
                        width: 310,
                        child: const ToggleNotifications(),
                        onTap: () {
                          context.read<HabitSettingsCubit>().toggleNotifications(!context.read<HabitSettingsCubit>().state.notifications);
                        },
                      ),
                      InputWidget(
                        text: 'Order Habits:',
                        icon: Icons.filter_list_rounded,
                        width: 310,
                        child: const SelectHabitOrdering(),
                        onTap: () async {
                          //await showOrderMenu(context);
                        },
                      ),
                      InputWidget(
                        text: 'Set Widget:',
                        icon: Icons.widgets_rounded,
                        width: 302,
                        child: const ToggleWidget(),
                        onTap: () {
                          context.read<HabitSettingsCubit>().toggleWidget(!context.read<HabitSettingsCubit>().state.setWidget);
                        },
                      ),
                      InputWidget(
                        text: 'Theme:',
                        icon: Icons.palette,
                        width: 241,
                        child: const SelectTheme(),
                        onTap: () {
                          
                        },
                      ),
                      InputWidget(
                        text: 'Primary color:',
                        icon: Icons.format_color_fill_rounded,
                        width: MediaQuery.of(context).size.width,
                        child: const ColorDisplay(colorString: 'primaryColor', width: 55),
                        onTap: () {
                          showColorPicker(context: context, pickerColor: MyColors().primaryColor, onColorChanged: (Color color) {
                            context.read<HabitSettingsCubit>().setPrimaryColor(color);
                          });
                        },
                      ),
                      InputWidget(
                        text: 'Secondary color:',
                        icon: Icons.format_color_fill_rounded,
                        width: MediaQuery.of(context).size.width,
                        child: const ColorDisplay(colorString: 'secondaryColor', width: 37),
                        onTap: () {
                          showColorPicker(context: context, pickerColor: MyColors().secondaryColor, onColorChanged: (Color color) {
                            context.read<HabitSettingsCubit>().setSecondaryColor(color);
                          });
                        },
                      ),
                      InputWidget(
                        text: 'Background color:',
                        icon: Icons.format_color_fill_rounded,
                        width: MediaQuery.of(context).size.width,
                        child: const ColorDisplay(colorString: 'backgroundColor', width: 25),
                        onTap: () {
                          showColorPicker(context: context, pickerColor: MyColors().backgroundColor, onColorChanged: (Color color) {
                            context.read<HabitSettingsCubit>().setBackgroundColor(color);
                          });
                        },
                      ),
                      InputWidget(
                        text: 'Widget color:',
                        icon: Icons.format_color_fill_rounded,
                        width: MediaQuery.of(context).size.width,
                        child: const ColorDisplay(colorString: 'widgetColor', width: 60),
                        onTap: () {
                          showColorPicker(context: context, pickerColor: MyColors().widgetColor, onColorChanged: (Color color) {
                            context.read<HabitSettingsCubit>().setWidgetColor(color);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}