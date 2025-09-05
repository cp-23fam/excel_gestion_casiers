// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LockerAdapter extends TypeAdapter<Locker> {
  @override
  final int typeId = 0;

  @override
  Locker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Locker(
      place: fields[0] as String,
      floor: fields[1] as String,
      number: fields[2] as int,
      responsible: fields[3] as String,
      student: fields[4] as Student?,
      caution: fields[5] as int,
      numberKeys: fields[6] as int,
      lockNumber: fields[7] as int,
      lockerCondition: fields[8] as LockerCondition,
    );
  }

  @override
  void write(BinaryWriter writer, Locker obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.place)
      ..writeByte(1)
      ..write(obj.floor)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.responsible)
      ..writeByte(4)
      ..write(obj.student)
      ..writeByte(5)
      ..write(obj.caution)
      ..writeByte(6)
      ..write(obj.numberKeys)
      ..writeByte(7)
      ..write(obj.lockNumber)
      ..writeByte(8)
      ..write(obj.lockerCondition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
