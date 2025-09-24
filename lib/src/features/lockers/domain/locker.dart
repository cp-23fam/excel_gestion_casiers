import 'package:hive_flutter/hive_flutter.dart';

import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';

part 'locker.g.dart';

typedef LockerID = String;

@HiveType(typeId: 0)
class Locker extends HiveObject {
  Locker({
    required this.place,
    required this.floor,
    required this.number,
    required this.responsible,
    required this.studentId,
    required this.numberKeys,
    required this.lockNumber,
    required this.lockerCondition,
    required this.id,
  });

  @HiveField(0)
  final String place;
  @HiveField(1)
  final String floor;
  @HiveField(2)
  final int number;
  @HiveField(3)
  final String responsible;
  @HiveField(4)
  final StudentID? studentId;
  @HiveField(5)
  final int numberKeys;
  @HiveField(6)
  final int lockNumber;
  @HiveField(7)
  final LockerCondition lockerCondition;
  @HiveField(8)
  final LockerID id;

  Locker returnFreedLocker() {
    return Locker(
      place: place,
      floor: floor,
      number: number,
      responsible: responsible,
      studentId: null,
      numberKeys: numberKeys,
      lockNumber: lockNumber,
      lockerCondition: lockerCondition,
      id: id,
    );
  }

  Locker copyWith({
    String? place,
    String? floor,
    int? number,
    String? responsible,
    StudentID? studentId,
    int? numberKeys,
    int? lockNumber,
    LockerCondition? lockerCondition,
    LockerID? id,
  }) {
    return Locker(
      place: place ?? this.place,
      floor: floor ?? this.floor,
      number: number ?? this.number,
      responsible: responsible ?? this.responsible,
      studentId: studentId ?? this.studentId,
      numberKeys: numberKeys ?? this.numberKeys,
      lockNumber: lockNumber ?? this.lockNumber,
      lockerCondition: lockerCondition ?? this.lockerCondition,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(covariant Locker other) {
    if (identical(this, other)) return true;

    return other.place == place &&
        other.floor == floor &&
        other.number == number &&
        other.responsible == responsible &&
        other.studentId == studentId &&
        other.numberKeys == numberKeys &&
        other.lockNumber == lockNumber &&
        other.lockerCondition == lockerCondition &&
        other.id == id;
  }

  @override
  int get hashCode {
    return place.hashCode ^
        floor.hashCode ^
        number.hashCode ^
        responsible.hashCode ^
        studentId.hashCode ^
        numberKeys.hashCode ^
        lockNumber.hashCode ^
        lockerCondition.hashCode ^
        id.hashCode;
  }
}
