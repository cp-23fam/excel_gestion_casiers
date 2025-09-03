import 'package:excel_gestion_casiers/src/models/locker.dart';
import 'package:excel_gestion_casiers/src/models/student.dart';
import 'package:flutter/material.dart';

class LockersProvder with ChangeNotifier {
  final _imported = <Locker>[];

  final _lockers = <Locker>[];
  final _students = <Student>[];

  List<Locker> get lockers => [..._lockers];
  List<Student> get students => [..._students];
  bool get getImportationDone => _imported.isNotEmpty;

  // Lockers

  void setLockersList(List<Locker> lockers) {
    _lockers.clear();
    _lockers.addAll(lockers);
    _imported.clear();
    _imported.addAll(lockers);
    notifyListeners();
  }

  void addLocker(Locker locker) {
    _lockers.add(locker);
    notifyListeners();
  }

  void editLocker(int lockerNumber, Locker editedLocker) {
    _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
        editedLocker;
    notifyListeners();
  }

  void freeLockerByIndex(int lockerNumber) {
    _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
        _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)]
            .returnFreedLocker();
    notifyListeners();
  }

  void addStudentByIdToLockerByIndex(int lockerNumber, String id) {
    _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)] =
        _lockers[_lockers.indexWhere((locker) => locker.number == lockerNumber)]
            .copyWith(
              student: _students.firstWhere((student) => student.id == id),
            );
    notifyListeners();
  }

  void erazeLocker(int lockerNumber) {
    _lockers.removeAt(
      _lockers.indexWhere((locker) => locker.number == lockerNumber),
    );
    notifyListeners();
  }

  void searchLocker(String searchValue) {
    late List<Locker> lockers;

    if (int.tryParse(searchValue) != null) {
      lockers = _imported
          .where((locker) => locker.number.toString().contains(searchValue))
          .toList();

      if (lockers.isEmpty) {
        lockers = _imported
            .where(
              (locker) => locker.lockNumber.toString().contains(searchValue),
            )
            .toList();
      }
    } else {
      lockers = [];
      for (Locker locker in _imported) {
        if (locker.student != null &&
            locker.student!.name.toLowerCase().contains(
              searchValue.toLowerCase(),
            )) {
          lockers.add(locker);
        }
      }
    }

    _lockers.clear();
    _lockers.addAll(lockers);
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
