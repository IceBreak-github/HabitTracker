import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject{
  Habit({
    required this.habitType,
    required this.name,
    this.time,
    this.notify,
    this.recurrence,
    this.date,
    this.goal,
    this.unit,
  });

  @HiveField(0)
  late String habitType;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String? time;

  @HiveField(3)
  late bool? notify;

  @HiveField(4)
  late dynamic recurrence;

  @HiveField(5)
  late dynamic date;

  @HiveField(6)
  late double? goal;

  @HiveField(7)
  late String? unit;

  @HiveField(8)
  Map<String, bool> completionDates = {};
}