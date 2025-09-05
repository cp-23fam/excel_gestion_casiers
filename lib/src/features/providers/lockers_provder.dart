import 'package:excel_gestion_casiers/src/models/locker.dart';
import 'package:excel_gestion_casiers/src/models/student.dart';
import 'package:excel_gestion_casiers/src/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LockersProvder with ChangeNotifier {
  final _showing = <Locker>[];

  final _students = <Student>[];
  bool _importationDone = false;

  final _transactions = <Transaction>[];

  List<Locker> get lockers => [..._showing];
  List<Student> get students => [..._students];
  bool get getImportationDone => _importationDone;

  // Transaction
  void saveTransaction(TransactionType type, int number, Locker value) {
    _transactions.add(Transaction(type, number, value));

    if (_transactions.length > 10) {
      _transactions.removeAt(0);
    }
  }

  void restoreTransaction() async {
    Box lockersBox = await Hive.openBox('lockers');

    if (_transactions.isEmpty) {
      return;
    }

    final transaction = _transactions.last;

    // final locker = lockersBox.get(transaction.lockerNumber);

    // final locker = _lockers.firstWhere(
    //   (locker) => locker.number == transaction.lockerNumber,
    // );

    switch (transaction.type) {
      case TransactionType.add:
        lockersBox.delete(transaction.lockerNumber);
        // _lockers.remove(transaction.previousValue);
        break;
      case TransactionType.remove:
        lockersBox.put(transaction.lockerNumber, transaction.previousValue);
        // _lockers.add(transaction.previousValue);
        break;
      case TransactionType.edit:
        lockersBox.put(transaction.lockerNumber, transaction.previousValue);
        // _lockers[_lockers.indexOf(locker)] = transaction.previousValue;
        break;
    }

    _transactions.removeLast();
  }

  // Lockers

  void fetchLockersList() async {
    final lockers = <Locker>[];

    Box<Locker> lockersBox = await Hive.openBox('lockers');
    for (int i = 0; i < lockersBox.length; i++) {
      final Locker? locker = lockersBox.getAt(i);

      if (locker != null) {
        lockers.add(locker);
      }
    }

    _showing.clear();
    _showing.addAll(lockers);

    if (_showing.isEmpty) {
      _importationDone = false;
    } else {
      _importationDone = true;
    }

    notifyListeners();
  }

  void setLockersList(List<Locker> lockers) async {
    Box<Locker> lockersBox = await Hive.openBox('lockers');
    await lockersBox.deleteAll(lockersBox.keys);
    // lockersBox = await Hive.openBox('lockers');

    for (Locker locker in lockers) {
      await lockersBox.put(locker.number, locker);
    }

    _showing.clear();
    _showing.addAll(lockers);
    _importationDone = true;
    notifyListeners();
  }

  void addLocker(Locker locker) async {
    Box lockersBox = await Hive.openBox('lockers');
    // _lockers.add(locker);
    lockersBox.put(locker.number, locker);
    saveTransaction(TransactionType.add, locker.number, locker);
    notifyListeners();
  }

  void editLocker(int lockerNumber, Locker editedLocker) async {
    Box lockersBox = await Hive.openBox('lockers');

    lockersBox.put(lockerNumber, editedLocker);
    // _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
    //     editedLocker;

    saveTransaction(TransactionType.edit, lockerNumber, editedLocker);
    notifyListeners();
  }

  void freeLockerByIndex(int lockerNumber) async {
    Box<Locker> lockersBox = await Hive.openBox('lockers');

    // final locker =
    //     _lockers[_lockers.indexWhere(
    //       (locker) => locker.number == lockerNumber,
    //     )];

    lockersBox.put(
      lockerNumber,
      lockersBox.get(lockerNumber)!.returnFreedLocker(),
    );
    // _lockers[_lockers.indexWhere(
    //   (locker) => locker.number == lockerNumber,
    // )] = locker
    //     .returnFreedLocker();
    saveTransaction(
      TransactionType.edit,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );
    notifyListeners();
  }

  void addStudentByIdToLockerByIndex(int lockerNumber, String id) async {
    Box<Locker> lockersBox = await Hive.openBox('lockers');
    // final locker =
    //     _lockers[_lockers.indexWhere(
    //       (locker) => locker.number == lockerNumber,
    //     )];

    // _lockers[_lockers.indexWhere(
    //   (locker) => locker.number == lockerNumber,
    // )] = locker.copyWith(
    //   student: _students.firstWhere((student) => student.id == id),
    // );

    lockersBox.put(
      lockerNumber,
      lockersBox
          .get(lockerNumber)!
          .copyWith(
            student: _students.firstWhere((student) => student.id == id),
          ),
    );

    saveTransaction(
      TransactionType.edit,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
    );
    notifyListeners();
  }

  void erazeLocker(int lockerNumber) async {
    Box<Locker> lockersBox = await Hive.openBox('lockers');
    saveTransaction(
      TransactionType.remove,
      lockerNumber,
      lockersBox.get(lockerNumber)!,
      // _lockers.firstWhere((locker) => locker.number == locker.lockNumber),
    );

    lockersBox.delete(lockerNumber);

    // _lockers.removeAt(
    //   _lockers.indexWhere((locker) => locker.number == lockerNumber),
    // );
    notifyListeners();
  }

  // void searchLocker(String searchValue) {
  // // ! FIXME integrate Hive
  //   late List<Locker> lockers;

  //   if (searchValue == '') {
  //     _showing.clear();
  //     _showing.addAll(_lockers);
  //     notifyListeners();
  //     return;
  //   }

  //   if (int.tryParse(searchValue) != null) {
  //     lockers = _lockers
  //         .where((locker) => locker.number.toString().contains(searchValue))
  //         .toList();

  //     if (lockers.isEmpty) {
  //       lockers = _lockers
  //           .where(
  //             (locker) => locker.lockNumber.toString().contains(searchValue),
  //           )
  //           .toList();
  //     }
  //   } else {
  //     lockers = [];
  //     for (Locker locker in _showing) {
  //       if (locker.student != null &&
  //           locker.student!.name.toLowerCase().contains(
  //             searchValue.toLowerCase(),
  //           )) {
  //         lockers.add(locker);
  //       }
  //     }
  //   }

  //   _showing.clear();
  //   _showing.addAll(lockers);
  //   notifyListeners();
  // }

  Future<Locker?> getLockerByNumber(int number) async {
    Box<Locker> lockersBox = await Hive.openBox('lockers');
    // late Locker? locker;
    // try {
    //   locker = _lockers.firstWhere((locker) => locker.number == number);
    // } catch (e) {
    //   locker = null;
    // }

    return lockersBox.get(number);
  }

  // Students

  // void createStudentListWithLockerList() {
  //   // ! FIXME integrate Hive
  //   _students.clear();

  //   for (Locker locker in _lockers) {
  //     if (locker.student != null) {
  //       _students.add(locker.student!);
  //     }
  //   }

  //   notifyListeners();
  // }

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
