// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locker_condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LockerConditionAdapter extends TypeAdapter<LockerCondition> {
  @override
  final int typeId = 2;

  @override
  LockerCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LockerCondition(
      fields[0] as bool,
      comments: fields[1] as String?,
      problems: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LockerCondition obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isLockerinGoodCondition)
      ..writeByte(1)
      ..write(obj.comments)
      ..writeByte(2)
      ..write(obj.problems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockerConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
