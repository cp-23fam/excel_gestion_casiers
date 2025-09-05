import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LockersRepository {
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

  List<Locker> fetchLockersList() {
    final lockers = <Locker>[];

    for (int i = 0; i < lockersBox.length; i++) {
      final Locker? locker = lockersBox.getAt(i);

      if (locker != null) {
        lockers.add(locker);
      }
    }

    _createStudentListWith(lockers);

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
    Box<Locker> lockersBox = await Hive.openBox('lockers');

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
      lockersBox.get(number)!.copyWith(student: studentsBox.get(studentId)!),
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

  void _createStudentListWith(List<Locker> lockers) {
    studentsBox.deleteAll(studentsBox.keys);

    for (Locker locker in lockers) {
      if (locker.student != null) {
        studentsBox.put(locker.student!.id, locker.student!);
      }
    }
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
