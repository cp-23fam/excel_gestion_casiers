import 'package:excel_gestion_casiers/src/models/locker.dart';
import 'package:excel_gestion_casiers/src/models/student.dart';
import 'package:excel_gestion_casiers/src/models/transaction.dart';
import 'package:flutter/material.dart';

class LockersProvder with ChangeNotifier {
  final _showing = <Locker>[];

  final _lockers = <Locker>[];
  final _students = <Student>[];

  final _transactions = <Transaction>[];

  List<Locker> get lockers => [..._showing];
  List<Student> get students => [..._students];
  bool get getImportationDone => _lockers.isNotEmpty;

  // Transaction
  void saveTransaction(TransactionType type, int number, Locker value) {
    _transactions.add(Transaction(type, number, value));

    if (_transactions.length > 10) {
      _transactions.removeAt(0);
    }
  }

  void restoreTransaction() {
    if (_transactions.isEmpty) {
      return;
    }

    final transaction = _transactions.last;

    final locker = _lockers.firstWhere(
      (locker) => locker.number == transaction.lockerNumber,
    );

    switch (transaction.type) {
      case TransactionType.add:
        _lockers.remove(transaction.previousValue);
      case TransactionType.remove:
        _lockers.add(transaction.previousValue);
      case TransactionType.edit:
        _lockers[_lockers.indexOf(locker)] = transaction.previousValue;
        break;
    }

    _transactions.removeLast();
  }

  // Lockers

  void setLockersList(List<Locker> lockers) {
    _lockers.clear();
    _lockers.addAll(lockers);
    _showing.clear();
    _showing.addAll(lockers);
    notifyListeners();
  }

  void addLocker(Locker locker) {
    _lockers.add(locker);
    saveTransaction(TransactionType.add, locker.number, locker);
    notifyListeners();
  }

  void editLocker(int lockerNumber, Locker editedLocker) {
    _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
        editedLocker;

    saveTransaction(TransactionType.edit, lockerNumber, editedLocker);
    notifyListeners();
  }

  void freeLockerByIndex(int lockerNumber) {
    final locker =
        _lockers[_lockers.indexWhere(
          (locker) => locker.number == lockerNumber,
        )];

    _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
        locker.returnFreedLocker();
    saveTransaction(TransactionType.edit, lockerNumber, locker);
    notifyListeners();
  }

  void addStudentByIdToLockerByIndex(int lockerNumber, String id) {
    final locker =
        _lockers[_lockers.indexWhere(
          (locker) => locker.number == lockerNumber,
        )];

    _lockers[_lockers.indexWhere(
      (locker) => locker.number == lockerNumber,
    )] = locker.copyWith(
      student: _students.firstWhere((student) => student.id == id),
    );
    saveTransaction(TransactionType.edit, lockerNumber, locker);
    notifyListeners();
  }

  void erazeLocker(int lockerNumber) {
    saveTransaction(
      TransactionType.remove,
      lockerNumber,
      _lockers.firstWhere((locker) => locker.number == locker.lockNumber),
    );
    _lockers.removeAt(
      _lockers.indexWhere((locker) => locker.number == lockerNumber),
    );
    notifyListeners();
  }

  void searchLocker(String searchValue) {
    late List<Locker> lockers;

    if (searchValue == '') {
      _showing.clear();
      _showing.addAll(_lockers);
      notifyListeners();
      return;
    }

    if (int.tryParse(searchValue) != null) {
      lockers = _lockers
          .where((locker) => locker.number.toString().contains(searchValue))
          .toList();

      if (lockers.isEmpty) {
        lockers = _lockers
            .where(
              (locker) => locker.lockNumber.toString().contains(searchValue),
            )
            .toList();
      }
    } else {
      lockers = [];
      for (Locker locker in _showing) {
        if (locker.student != null &&
            locker.student!.name.toLowerCase().contains(
              searchValue.toLowerCase(),
            )) {
          lockers.add(locker);
        }
      }
    }

    _showing.clear();
    _showing.addAll(lockers);
    notifyListeners();
  }

  Locker? getLockerByNumber(int number) {
    late Locker? locker;
    try {
      locker = _lockers.firstWhere((locker) => locker.number == number);
    } catch (e) {
      locker = null;
    }

    return locker;
  }

  Locker? getLockerByStudentName(String name) {
    late Locker? locker;
    try {
      locker = _lockers.firstWhere((locker) => locker.student?.name == name);
    } catch (e) {
      locker = null;
    }

    return locker;
  }

  // Students

  void createStudentListWithLockerList() {
    _students.clear();

    for (Locker locker in _lockers) {
      if (locker.student != null) {
        _students.add(locker.student!);
      }
    }

    notifyListeners();
  }

  void createStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void editStudent(String id, Student editedStudent) {
    final studentIndex = _students.indexWhere((student) => student.id == id);

    _students[studentIndex] = editedStudent;
    notifyListeners();
  }

  void erazeStudentWithId(String id) {
    _students.remove(_students.firstWhere((student) => student.id == id));
    notifyListeners();
  }
}
