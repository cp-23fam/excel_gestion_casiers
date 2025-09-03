// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:excel_gestion_casiers/src/models/locker_condition.dart';
import 'package:excel_gestion_casiers/src/models/student.dart';

class Locker {
  const Locker({
    required this.place,
    required this.floor,
    required this.number,
    required this.responsible,
    required this.student,
    required this.caution,
    required this.numberKeys,
    required this.lockNumber,
    required this.lockerCondition,
  });

  final String place;
  final String floor;
  final int number;
  final String responsible;
  final Student? student;
  final int caution;
  final int numberKeys;
  final int lockNumber;
  final LockerCondition lockerCondition;

  Locker returnFreedLocker() {
    return Locker(
      place: place,
      floor: floor,
      number: number,
      responsible: responsible,
      student: null,
      caution: caution,
      numberKeys: numberKeys,
      lockNumber: lockNumber,
      lockerCondition: lockerCondition,
    );
  }

  Locker copyWith({
    String? place,
    String? floor,
    int? number,
    String? responsible,
    Student? student,
    int? caution,
    int? numberKeys,
    int? lockNumber,
    LockerCondition? lockerCondition,
  }) {
    return Locker(
      place: place ?? this.place,
      floor: floor ?? this.floor,
      number: number ?? this.number,
      responsible: responsible ?? this.responsible,
      student: student ?? this.student,
      caution: caution ?? this.caution,
      numberKeys: numberKeys ?? this.numberKeys,
      lockNumber: lockNumber ?? this.lockNumber,
      lockerCondition: lockerCondition ?? this.lockerCondition,
    );
  }
}
