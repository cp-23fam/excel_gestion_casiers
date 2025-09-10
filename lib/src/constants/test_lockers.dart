import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';

final testLockers = [
  Locker(
    place: 'Ancien Batiment',
    number: 122,
    responsible: 'JHI',
    studentId: '1',
    floor: 'c',
    numberKeys: 2,
    lockNumber: 45502,
    lockerCondition: LockerCondition.good(),
    id: '1',
  ),
  Locker(
    place: 'Ancien Batiment',
    number: 123,
    responsible: 'JHI',
    studentId: '2',
    floor: 'c',
    numberKeys: 2,
    lockNumber: 45503,
    lockerCondition: LockerCondition.good(),
    id: '2',
  ),
  Locker(
    place: 'Ancien Batiment',
    number: 124,
    responsible: 'JHI',
    studentId: '3',
    floor: 'c',
    numberKeys: 2,
    lockNumber: 45504,
    lockerCondition: LockerCondition.good(),
    id: '3',
  ),
  Locker(
    place: 'Ancien Batiment',
    number: 125,
    responsible: 'JHI',
    studentId: '4',
    floor: 'c',
    numberKeys: 2,
    lockNumber: 45505,
    lockerCondition: LockerCondition.good(),
    id: '4',
  ),
];
