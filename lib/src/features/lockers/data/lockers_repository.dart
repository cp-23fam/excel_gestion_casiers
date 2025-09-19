import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/transactions/data/transaction_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/transactions/domain/transaction.dart';
import 'package:excel_gestion_casiers/src/utils/lockers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class LockersRepository extends Notifier<List<Locker>> {
  static final Box<Locker> lockersBox = Hive.box('lockers');

  // Lockers
  void importLockersFromList(List<Locker> lockers) {
    lockersBox.deleteAll(lockersBox.keys);

    for (Locker locker in lockers) {
      lockersBox.put(locker.number, runAutoHealthCheckOnLocker(locker));
    }
  }

  List<Locker> fetchLockersList() {
    final lockers = <Locker>[];

    for (int i = 0; i < lockersBox.length; i++) {
      final Locker? locker = lockersBox.getAt(i);

      if (locker != null) {
        lockers.add(locker);
      }
    }

    return lockers;
  }

  List<Locker> fetchFreeLockers() {
    final lockers = <Locker>[];

    for (int i = 0; i < lockersBox.length; i++) {
      final Locker? locker = lockersBox.getAt(i);

      if (locker != null && locker.studentId == null) {
        lockers.add(locker);
      }
    }

    return lockers;
  }

  Locker? getLockerById(int lockerNumber) {
    try {
      return lockersBox.values.firstWhere(
        (locker) => locker.number == lockerNumber,
      );
    } on StateError {
      return null;
    }
  }

  Future<void> freeLockerByIndex(int lockerNumber) async {
    TransactionRepository().saveTransaction(
      TransactionType.edit,
      isStudentBox: false,
      lockerValue: lockersBox.get(lockerNumber)!,
    );

    lockersBox.put(
      lockerNumber,
      lockersBox.get(lockerNumber)!.returnFreedLocker(),
    );
  }

  Future<void> addStudentToLockerBy(int number, String studentId) async {
    TransactionRepository().saveTransaction(
      TransactionType.edit,
      isStudentBox: false,
      lockerValue: lockersBox.get(number)!,
    );

    lockersBox.put(
      number,
      lockersBox
          .get(number)!
          .copyWith(
            studentId: StudentsRepository.studentsBox.get(studentId)!.id,
          ),
    );
  }

  void addLocker(Locker locker) {
    final checkedLocker = runAutoHealthCheckOnLocker(locker);

    TransactionRepository().saveTransaction(
      TransactionType.add,
      isStudentBox: false,
      lockerValue: locker,
    );

    LockersRepository.lockersBox.put(locker.number, checkedLocker);
  }

  void editLocker(int lockerNumber, Locker editedLocker) {
    final checkedLocker = runAutoHealthCheckOnLocker(editedLocker);

    TransactionRepository().saveTransaction(
      TransactionType.edit,
      isStudentBox: false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.put(lockerNumber, checkedLocker);
  }

  void deleteLocker(int lockerNumber) {
    TransactionRepository().saveTransaction(
      TransactionType.remove,
      isStudentBox: false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.delete(lockerNumber);
  }

  Student? getStudentByLocker(int lockerNumber) {
    final Locker? locker = lockersBox.get(lockerNumber);

    if (locker == null || locker.studentId == null) {
      return null;
    }

    return StudentsRepository.studentsBox.get(locker.studentId);
  }

  @override
  build() {
    return [];
  }
}

final lockersRepositoryProvider =
    NotifierProvider<LockersRepository, List<Locker>>(() {
      return LockersRepository();
    });
