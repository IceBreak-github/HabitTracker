// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      vibrations: fields[0] as bool,
      notifications: fields[1] as bool,
      orderHabits: fields[2] as String,
      setWidget: fields[3] as bool,
      theme: fields[4] as String,
      primaryColor: fields[5] as String,
      secondaryColor: fields[6] as String,
      backgroundColor: fields[7] as String,
      widgetColor: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.vibrations)
      ..writeByte(1)
      ..write(obj.notifications)
      ..writeByte(2)
      ..write(obj.orderHabits)
      ..writeByte(3)
      ..write(obj.setWidget)
      ..writeByte(4)
      ..write(obj.theme)
      ..writeByte(5)
      ..write(obj.primaryColor)
      ..writeByte(6)
      ..write(obj.secondaryColor)
      ..writeByte(7)
      ..write(obj.backgroundColor)
      ..writeByte(8)
      ..write(obj.widgetColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
