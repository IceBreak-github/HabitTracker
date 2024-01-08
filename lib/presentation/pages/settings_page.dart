import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:habit_tracker/data/models/settings_model.dart';
import 'package:habit_tracker/logic/cubits/habit_settings_cubit.dart';
import 'package:habit_tracker/logic/services/notification_service.dart';
import 'package:habit_tracker/presentation/widgets/settings_widget.dart';
import 'package:habit_tracker/presentation/widgets/widgets.dart';
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
                          onTap: () async {
                            bool canVibrate = await Vibrate.canVibrate;
                            if(context.mounted){
                              if(!canVibrate){
                                showToast(context: context, icon: Icons.tune_rounded, text: 'Unsupported device');
                              }
                              else{
                                settings.vibrations = !settings.vibrations;
                                boxSettings.put(0, settings);
                                context.read<HabitSettingsCubit>().toggleVibrations(!context.read<HabitSettingsCubit>().state.vibrations);
                              }
                            }
                          },
                        ),
                        SettingsWidget(            //TODO inform the user that notifications have been enabled/disabled globally, and present notifications have been removed or rescheduled
                          text: 'Notifications:',
                          icon: Icons.notifications_active_rounded,
                          child: const ToggleNotifications(),
                          onTap: () async {
                            if(settings.notifications){  //initially set to true, removing all scheduled notifications
                              await AwesomeNotifications().cancelAll();
                            }
                            if(!settings.notifications){      //initialy set to false, planning the notificions again
                              await NotificationService.notificationPlanner();
                            }
                            if(context.mounted){
                              settings.notifications = !settings.notifications;
                              boxSettings.put(0, settings);
                              context.read<HabitSettingsCubit>().toggleNotifications(!context.read<HabitSettingsCubit>().state.notifications);
                              //ScaffoldMessenger.of(context).showSnackBar(customSnackBar(text: 'This is a snackbar'));
                            }
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