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
            child: ScrollConfiguration(
              behavior: const ScrollBehavior()
              .copyWith(overscroll: false), 
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        SettingsWidget(
                          text: 'Vibrations:',
                          icon: Icons.edgesensor_high_rounded,
                          child: const ToggleVibrations(),
                          onTap: () {
                            context.read<HabitSettingsCubit>().toggleVibrations(!context.read<HabitSettingsCubit>().state.vibrations);
                          },
                        ),
                        SettingsWidget(
                          text: 'Notifications:',
                          icon: Icons.notifications_active_rounded,
                          child: const ToggleNotifications(),
                          onTap: () {
                            context.read<HabitSettingsCubit>().toggleNotifications(!context.read<HabitSettingsCubit>().state.notifications);
                          },
                        ),
                        SettingsWidget(
                          text: 'Order Habits:',
                          icon: Icons.filter_list_rounded,
                          child: const SelectHabitOrdering(),
                          onTap: () async {
                            //await showOrderMenu(context);
                          },
                        ),
                        SettingsWidget(
                          text: 'Set Widget:',
                          icon: Icons.widgets_rounded,
                          child: const ToggleWidget(),
                          onTap: () {
                            context.read<HabitSettingsCubit>().toggleWidget(!context.read<HabitSettingsCubit>().state.setWidget);
                          },
                        ),
                        SettingsWidget(
                          text: 'Theme:',
                          icon: Icons.palette,
                          child: const SelectTheme(),
                          onTap: () {
                            
                          },
                        ),
                        SettingsWidget(
                          text: 'Primary color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'primaryColor', width: 55),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: MyColors().primaryColor, onColorChanged: (Color color) {
                              context.read<HabitSettingsCubit>().setPrimaryColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Secondary color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'secondaryColor', width: 37),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: MyColors().secondaryColor, onColorChanged: (Color color) {
                              context.read<HabitSettingsCubit>().setSecondaryColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Background color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'backgroundColor', width: 25),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: MyColors().backgroundColor, onColorChanged: (Color color) {
                              context.read<HabitSettingsCubit>().setBackgroundColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Widget color:',
                          icon: Icons.format_color_fill_rounded,
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
          ),
        ],
      ),
    );
  }
}