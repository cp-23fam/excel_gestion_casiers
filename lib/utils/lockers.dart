import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';

List<Locker> runAutoHealthCheckOnLockers(List<Locker> lockers) {
  final checkedLockers = <Locker>[];

  for (Locker locker in lockers) {
    LockerCondition lockerCondition = locker.lockerCondition;

    if (locker.numberKeys == 0) {
      lockerCondition = lockerCondition.copyWith(
        isLockerinGoodCondition: false,
        problems: 'Il n\'y a plus de clés',
      );
    }

    checkedLockers.add(locker.copyWith(lockerCondition: lockerCondition));
  }

  return checkedLockers;
}
