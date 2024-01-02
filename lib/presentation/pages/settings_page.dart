import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/data/models/settings_model.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/presentation/widgets/settings_widget.dart';
import 'package:habit_tracker/shared/boxes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    Settings settings = boxSettings.get(0);
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
                            settings.vibrations = !settings.vibrations;
                            boxSettings.put(0, settings);
                            context.read<HabitSettingsCubit>().toggleVibrations(!context.read<HabitSettingsCubit>().state.vibrations);
                          },
                        ),
                        SettingsWidget(
                          text: 'Notifications:',
                          icon: Icons.notifications_active_rounded,
                          child: const ToggleNotifications(),
                          onTap: () {
                            settings.notifications = !settings.notifications;
                            boxSettings.put(0, settings);
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
                            settings.setWidget = !settings.setWidget;
                            boxSettings.put(0, settings);
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
                            showColorPicker(context: context, pickerColor: Color(int.parse(settings.primaryColor, radix: 16)), onColorChanged: (Color color) {
                              settings.primaryColor = color.value.toRadixString(16);
                              boxSettings.put(0, settings);
                              context.read<HabitSettingsCubit>().setPrimaryColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Secondary color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'secondaryColor', width: 37),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: Color(int.parse(settings.secondaryColor, radix: 16)), onColorChanged: (Color color) {  //TODO when the color is changed, this stays the same since it doesnt emit state
                              settings.secondaryColor = color.value.toRadixString(16);
                              boxSettings.put(0, settings);
                              context.read<HabitSettingsCubit>().setSecondaryColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Background color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'backgroundColor', width: 25),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: Color(int.parse(settings.backgroundColor, radix: 16)), onColorChanged: (Color color) {
                              settings.backgroundColor = color.value.toRadixString(16);
                              boxSettings.put(0, settings);
                              context.read<HabitSettingsCubit>().setBackgroundColor(color);
                            });
                          },
                        ),
                        SettingsWidget(
                          text: 'Widget color:',
                          icon: Icons.format_color_fill_rounded,
                          child: const ColorDisplay(colorString: 'widgetColor', width: 60),
                          onTap: () {
                            showColorPicker(context: context, pickerColor: Color(int.parse(settings.widgetColor, radix: 16)), onColorChanged: (Color color) {
                              settings.widgetColor = color.value.toRadixString(16);
                              boxSettings.put(0, settings);
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