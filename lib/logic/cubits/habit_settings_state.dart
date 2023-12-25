part of 'habit_settings_cubit.dart';

class HabitSettingsState extends Equatable {
  final bool notifications;
  final bool vibrations;
  final String orderHabits;
  final bool setWidget;

  const HabitSettingsState({
    this.notifications = true,
    this.vibrations = true,
    this.orderHabits = 'Automat.',
    this.setWidget = false,
  });
  
  HabitSettingsState copyWith({
    bool? notifications,
    bool? vibrations,
    String? orderHabits,
    bool? setWidget,
  }){
    return HabitSettingsState(
      notifications : notifications ?? this.notifications,
      vibrations : vibrations ?? this.vibrations,      
      orderHabits: orderHabits ?? this.orderHabits,   
      setWidget: setWidget ?? this.setWidget,  
    );
  }

  @override
  List<Object?> get props => [notifications, vibrations, orderHabits, setWidget];
}
