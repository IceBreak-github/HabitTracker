// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      habitType: fields[0] as String,
      name: fields[1] as String,
      time: fields[2] as String?,
      notify: fields[3] as bool?,
      recurrence: fields[4] as dynamic,
      date: fields[5] as dynamic,
      goal: fields[6] as int?,
      unit: fields[7] as String?,
      completionDates: (fields[8] as Map).cast<String, bool>(),
      measurementValues: (fields[9] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.habitType)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.notify)
      ..writeByte(4)
      ..write(obj.recurrence)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.goal)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.completionDates)
      ..writeByte(9)
      ..write(obj.measurementValues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
