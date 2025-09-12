import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class LockersRepository {
  static final Box<Locker> lockersBox = Hive.box('lockers');
  static final Box<Student> studentsBox = Hive.box('students');
  static final Box<Transaction> transactionsBox = Hive.box('transactions');

  // Transaction
  void saveTransaction(
    TransactionType type,
    bool isStudentBox, {
    Locker? lockerValue,
    Student? studentValue,
  }) {
    if (isStudentBox && studentValue == null) {
      return;
    }

    if (!isStudentBox && lockerValue == null) {
      return;
    }

    final String id = uuid.v4();
    if (isStudentBox) {
      transactionsBox.put(
        id,
        Transaction(
          id: id,
          type: type,
          boxItemId: studentValue!.id,
          previousValue: studentValue,
          isStudentBox: true,
        ),
      );
    } else {
      transactionsBox.put(
        id,
        Transaction(
          id: id,
          type: type,
          boxItemId: lockerValue!.number.toString(),
          isStudentBox: false,
          previousValue: lockerValue,
        ),
      );
    }
  }

  void goBack(String id) {
    if (transactionsBox.keys.isEmpty) {
      return;
    }

    final transaction = transactionsBox.get(id);

    if (transaction == null) {
      return;
    }

    if (transaction.isStudentBox) {
    } else {
      int lockerNumber = int.parse(transaction.boxItemId);

      Locker locker = transaction.previousValue as Locker;

      switch (transaction.type) {
        case TransactionType.add:
          lockersBox.delete(lockerNumber);
          break;
        case TransactionType.remove:
          lockersBox.put(lockerNumber, locker);
          break;
        case TransactionType.edit:
          lockersBox.put(lockerNumber, locker);
          break;
      }
    }

    transactionsBox.delete(id);
  }

  List<Transaction> fetchTransactionList() {
    final transactions = <Transaction>[];

    for (int i = 0; i < transactionsBox.length; i++) {
      final Transaction? transaction = transactionsBox.getAt(i);

      if (transaction != null) {
        transactions.add(transaction);
      }
    }

    return transactions;
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
    saveTransaction(
      TransactionType.edit,
      false,
      lockerValue: lockersBox.get(lockerNumber)!,
    );

    lockersBox.put(
      lockerNumber,
      lockersBox.get(lockerNumber)!.returnFreedLocker(),
    );
  }

  Future<void> addStudentToLockerBy(int number, String studentId) async {
    saveTransaction(
      TransactionType.edit,
      false,
      lockerValue: lockersBox.get(number)!,
    );

    lockersBox.put(
      number,
      lockersBox
          .get(number)!
          .copyWith(studentId: studentsBox.get(studentId)!.id),
    );
  }

  void addLocker(Locker locker) {
    LockersRepository().saveTransaction(
      TransactionType.add,
      false,
      lockerValue: locker,
    );

    LockersRepository.lockersBox.put(locker.number, locker);
  }

  void editLocker(int lockerNumber, Locker editedLocker) {
    LockersRepository().saveTransaction(
      TransactionType.edit,
      false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.put(lockerNumber, editedLocker);
  }

  void deleteLocker(int lockerNumber) {
    LockersRepository().saveTransaction(
      TransactionType.remove,
      false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.delete(lockerNumber);
  }

  Student? getStudentByLocker(int lockerNumber) {
    final Locker? locker = lockersBox.get(lockerNumber);

    if (locker == null || locker.studentId == null) {
      return null;
    }

    return studentsBox.get(locker.studentId);
  }

  // Students
  void importStudentsFromList(List<Student> students) {
    studentsBox.deleteAll(studentsBox.keys);

    for (Student student in students) {
      studentsBox.put(student.id, student);
    }

    for (Locker locker in lockersBox.values) {
      final studentIdInLocker = locker.studentId ?? '';
      bool willReset = true;

      for (Student student in students) {
        if (student.id == studentIdInLocker) {
          willReset = false;
          break;
        }
      }

      if (willReset) {
        lockersBox.put(locker.number, locker.copyWith(studentId: null));
      }
    }
  }

  List<Student> fetchNoLockerStudents() {
    final lockers = <Student>[];

    for (int i = 0; i < lockersBox.length; i++) {
      final Student? student = studentsBox.getAt(i);

      if (student != null) {
        if (getLockerByStudent(student.id) == null) {
          lockers.add(student);
        }
      }
    }

    return lockers;
  }

  Student? getStudentBy(StudentID id) {
    return studentsBox.get(id);
  }

  Locker? getLockerByStudent(StudentID id) {
    for (int lockerNumber in lockersBox.keys) {
      final Locker locker = lockersBox.get(lockerNumber)!;

      if (locker.studentId == id) {
        return locker;
      }
    }

    return null;
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

  void addStudent(Student student) {
    LockersRepository().saveTransaction(
      TransactionType.add,
      true,
      studentValue: student,
    );

    LockersRepository.studentsBox.put(student.id, student);
  }

  void editStudent(Student editedStudent) {
    LockersRepository().saveTransaction(
      TransactionType.edit,
      true,
      studentValue: LockersRepository.studentsBox.get(editedStudent.id),
    );

    LockersRepository.studentsBox.put(editedStudent.id, editedStudent);
  }

  void deleteStudent(String id) {
    LockersRepository().saveTransaction(
      TransactionType.remove,
      true,
      studentValue: LockersRepository.studentsBox.get(id)!,
    );

    LockersRepository.studentsBox.delete(id);
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

  void addLocker(Locker locker) {
    LockersRepository().saveTransaction(
      TransactionType.add,
      false,
      lockerValue: locker,
    );

    LockersRepository.lockersBox.put(locker.number, locker);
  }

  void editLocker(int lockerNumber, Locker editedLocker) {
    LockersRepository().saveTransaction(
      TransactionType.edit,
      false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.put(lockerNumber, editedLocker);
  }

  void deleteLocker(int lockerNumber) {
    LockersRepository().saveTransaction(
      TransactionType.remove,
      false,
      lockerValue: LockersRepository.lockersBox.get(lockerNumber)!,
    );

    LockersRepository.lockersBox.delete(lockerNumber);
  }

  void addStudent(Student student) {
    LockersRepository().saveTransaction(
      TransactionType.add,
      true,
      studentValue: student,
    );

    LockersRepository.studentsBox.put(student.id, student);
  }

  void editStudent(Student editedStudent) {
    LockersRepository().saveTransaction(
      TransactionType.edit,
      true,
      studentValue: LockersRepository.studentsBox.get(editedStudent.id),
    );

    LockersRepository.studentsBox.put(editedStudent.id, editedStudent);
  }

  void deleteStudent(String id) {
    LockersRepository().saveTransaction(
      TransactionType.remove,
      true,
      studentValue: LockersRepository.studentsBox.get(id)!,
    );

    LockersRepository.studentsBox.delete(id);
  }
}

final lockersListNotifierProvider =
    NotifierProvider<LockersListNotifier, List<Locker>>(() {
      return LockersListNotifier();
    });
