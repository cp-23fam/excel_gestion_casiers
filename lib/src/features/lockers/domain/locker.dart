import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';

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
    required this.caution,
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
  final int caution;
  @HiveField(6)
  final int numberKeys;
  @HiveField(7)
  final int lockNumber;
  @HiveField(8)
  final LockerCondition lockerCondition;
  @HiveField(9)
  final LockerID id;

  Locker returnFreedLocker() {
    return Locker(
      place: place,
      floor: floor,
      number: number,
      responsible: responsible,
      studentId: null,
      caution: caution,
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
    int? caution,
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
      caution: caution ?? this.caution,
      numberKeys: numberKeys ?? this.numberKeys,
      lockNumber: lockNumber ?? this.lockNumber,
      lockerCondition: lockerCondition ?? this.lockerCondition,
      id: id ?? this.id,
    );
  }
}
