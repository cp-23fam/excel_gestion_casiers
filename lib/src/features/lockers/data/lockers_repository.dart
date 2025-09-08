import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LockersRepository {
  static LockersRepository get instance => LockersRepository._();
  LockersRepository._();

  final Box<Locker> lockersBox = Hive.box('lockers');
  final Box<Student> studentsBox = Hive.box('students');

  final _transactions = <Transaction>[];

  // Transaction
  void _saveTransaction(TransactionType type, int number, Locker value) {
    _transactions.add(Transaction(type, number, value));

    if (_transactions.length > 10) {
      _transactions.removeAt(0);
    }
  }

  void goBack() async {
    if (_transactions.isEmpty) {
      return;
    }

    final transaction = _transactions.last;

    switch (transaction.type) {
      case TransactionType.add:
        lockersBox.delete(transaction.lockerNumber);
        break;
      case TransactionType.remove:
        lockersBox.put(transaction.lockerNumber, transaction.previousValue);
        break;
      case TransactionType.edit:
        lockersBox.put(transaction.lockerNumber, transaction.previousValue);
        break;
    }

    _transactions.removeLast();
  }

  // Lockers

  void importLockersFrom(List<Locker> lockers) {
    lockersBox.deleteAll(lockersBox.keys);

    for (Locker locker in lockers) {
      lockersBox.put(locker.number, locker);
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

  void addLocker(Locker locker) async {
    lockersBox.put(locker.number, locker);
    _saveTransaction(TransactionType.add, locker.number, locker);
  }

  void editLocker(int lockerNumber, Locker editedLocker) async {
    lockersBox.put(lockerNumber, editedLocker);
    _saveTransaction(TransactionType.edit, lockerNumber, editedLocker);
  }

  void freeLockerByIndex(int lockerNumber) async {
    lockersBox.put(
      lockerNumber,
      lockersBox.get(lockerNumber)!.returnFreedLocker(),
    );

    _saveTransaction(
      TransactionType.edit,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );
  }

  void addStudentToLockerBy(int number, String studentId) async {
    lockersBox.put(
      number,
      lockersBox.get(number)!.copyWith(student: studentsBox.get(studentId)!.id),
    );

    _saveTransaction(TransactionType.edit, number, lockersBox.get(number)!);
  }

  void erazeLocker(int lockerNumber) async {
    _saveTransaction(
      TransactionType.remove,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );

    lockersBox.delete(lockerNumber);
  }

  // Students

  Student? getStudentBy(String id) {
    return studentsBox.get(id);
  }

  List<Student> fetchStudents() {
    final students = <Student>[];

    for (int i = 0; i < studentsBox.length; i++) {
      final Student? student = studentsBox.getAt(i);

      if (student != null) {
        students.add(student);
      }
    }

    return students;
  }

  void createStudent(Student student) {
    studentsBox.put(student.id, student);
  }

  void editStudent(String id, Student editedStudent) {
    studentsBox.put(editedStudent.id, editedStudent);
  }

  void erazeStudentBy(String id) {
    studentsBox.delete(id);
  }
}

final lockersRepositoryProvider = Provider<LockersRepository>((ref) {
  return LockersRepository.instance;
});
