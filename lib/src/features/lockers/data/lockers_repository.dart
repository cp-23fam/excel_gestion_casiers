import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LockersRepository {
  static final Box<Locker> lockersBox = Hive.box('lockers');
  static final Box<Student> studentsBox = Hive.box('students');

  final _transactions = <Transaction>[];

  // Transaction
  void saveTransaction(TransactionType type, int number, Locker value) {
    _transactions.add(Transaction(type, number, value));

    if (_transactions.length > 10) {
      _transactions.removeAt(0);
    }
  }

  Future<void> goBack() async {
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
  void importLockersFromList(List<Locker> lockers) {
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

  Future<void> addLocker(Locker locker) async {
    lockersBox.put(locker.number, locker);
    saveTransaction(TransactionType.add, locker.number, locker);
  }

  Future<void> editLocker(int lockerNumber, Locker editedLocker) async {
    lockersBox.put(lockerNumber, editedLocker);
    saveTransaction(TransactionType.edit, lockerNumber, editedLocker);
  }

  Future<void> freeLockerByIndex(int lockerNumber) async {
    lockersBox.put(
      lockerNumber,
      lockersBox.get(lockerNumber)!.returnFreedLocker(),
    );

    saveTransaction(
      TransactionType.edit,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );
  }

  Future<void> addStudentToLockerBy(int number, String studentId) async {
    lockersBox.put(
      number,
      lockersBox
          .get(number)!
          .copyWith(studentId: studentsBox.get(studentId)!.id),
    );

    saveTransaction(TransactionType.edit, number, lockersBox.get(number)!);
  }

  Future<void> erazeLocker(int lockerNumber) async {
    saveTransaction(
      TransactionType.remove,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );

    lockersBox.delete(lockerNumber);
  }

  // Students
  void importStudentsFromList(List<Student> students) {
    studentsBox.deleteAll(studentsBox.keys);

    for (Student student in students) {
      studentsBox.put(student.id, student);
    }
  }

  Student? getStudentBy(StudentID id) {
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

  // Health
  void runAutoHealthCheckOnLockers() {
    for (Locker lockerId in lockersBox.keys) {
      Locker locker = lockersBox.get(lockerId)!;
      LockerCondition lockerCondition = locker.lockerCondition;

      if (locker.numberKeys == 0) {
        lockerCondition = lockerCondition.copyWith(
          isConditionGood: false,
          problems: 'Il n\'y a plus de clés',
        );
      }

      locker.copyWith(lockerCondition: lockerCondition);

      lockersBox.put(locker.number, locker);
    }
  }

  void runAutoEmptyLockerOnInvalidStudentId() {
    for (Locker lockerId in lockersBox.keys) {
      Locker locker = lockersBox.get(lockerId)!;

      if (locker.studentId != null &&
          !studentsBox.keys.contains(locker.studentId)) {
        locker = locker.returnFreedLocker();

        lockersBox.put(lockerId, locker);
      }
    }
  }
}

final lockersRepositoryProvider = Provider<LockersRepository>((ref) {
  return LockersRepository();
});

class LockersListNotifier extends Notifier<List<Locker>> {
  @override
  List<Locker> build() {
    return LockersRepository().fetchLockersList();
  }

  Locker? getLockerById(String lockerId) {
    return state.firstWhere((locker) => locker.id == lockerId);
  }

  Future<void> addLocker(Locker locker) async {
    LockersRepository.lockersBox.put(locker.number, locker);
    LockersRepository().saveTransaction(
      TransactionType.add,
      locker.number,
      locker,
    );
  }

  Future<void> editLocker(int lockerNumber, Locker editedLocker) async {
    LockersRepository.lockersBox.put(lockerNumber, editedLocker);
    LockersRepository().saveTransaction(
      TransactionType.edit,
      lockerNumber,
      editedLocker,
    );
  }

  Future<void> addStudent(Student student) async {
    LockersRepository.studentsBox.put(student.id, student);
  }

  Future<void> editStudent(Student editedStudent) async {
    LockersRepository.studentsBox.put(editedStudent.id, editedStudent);
  }
}

final lockersListNotifierProvider =
    NotifierProvider<LockersListNotifier, List<Locker>>(() {
      return LockersListNotifier();
    });
