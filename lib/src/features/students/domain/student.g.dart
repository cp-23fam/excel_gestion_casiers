// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 1;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as String,
      genderTitle: fields[1] as String,
      name: fields[2] as String,
      surname: fields[3] as String,
      job: fields[4] as String,
      caution: fields[5] as int,
      formationYear: fields[6] as int,
      login: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.genderTitle)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.surname)
      ..writeByte(4)
      ..write(obj.job)
      ..writeByte(5)
      ..write(obj.caution)
      ..writeByte(6)
      ..write(obj.formationYear)
      ..writeByte(7)
      ..write(obj.login);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
