import 'package:habit_tracker/shared/colors.dart';
import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject{
  Settings({
    this.vibrations = true,
    this.notifications = true,
    this.orderHabits = 'Automat.',
    this.setWidget = false,
    this.theme = 'Dark',
    this.primaryColor = 'ff00ffc1',
    this.secondaryColor = 'ff90ffe4',
    this.backgroundColor = 'ff121219',
    this.widgetColor = 'ff22222d',
  }); 

  @HiveField(0)
  bool vibrations = true;

  @HiveField(1)
  bool notifications = true;

  @HiveField(2)
  String orderHabits = 'Automat.';

  @HiveField(3)
  bool setWidget = false;

  @HiveField(4)
  String theme = 'Dark';

  @HiveField(5)
  String primaryColor = MyColors().primaryColor.value.toRadixString(16);

  @HiveField(6)
  String secondaryColor = MyColors().secondaryColor.value.toRadixString(16);

  @HiveField(7)
  String backgroundColor = MyColors().backgroundColor.value.toRadixString(16);

  @HiveField(8)
  String widgetColor = MyColors().widgetColor.value.toRadixString(16);
}