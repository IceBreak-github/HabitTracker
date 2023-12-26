part of 'habit_settings_cubit.dart';

class HabitSettingsState extends Equatable {
  final bool notifications;
  final bool vibrations;
  final String orderHabits;
  final bool setWidget;
  final String theme;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  final Color? widgetColor;

  const HabitSettingsState({
    this.notifications = true,
    this.vibrations = true,
    this.orderHabits = 'Automat.',
    this.setWidget = false,
    this.theme = 'Dark',
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.widgetColor,
  });
  
  HabitSettingsState copyWith({
    bool? notifications,
    bool? vibrations,
    String? orderHabits,
    bool? setWidget,
    String? theme,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? widgetColor,
  }){
    return HabitSettingsState(
      notifications : notifications ?? this.notifications,
      vibrations : vibrations ?? this.vibrations,      
      orderHabits: orderHabits ?? this.orderHabits,   
      setWidget: setWidget ?? this.setWidget,  
      theme: theme ?? this.theme,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      widgetColor: widgetColor ?? this.widgetColor,
    );
  }

  @override
  List<Object?> get props => [notifications, vibrations, orderHabits, setWidget, theme, primaryColor, secondaryColor, backgroundColor, widgetColor];
}
