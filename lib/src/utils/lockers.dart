import 'dart:math';

import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:uuid/uuid.dart';

List<Locker> searchInLockers(List<Locker> lockers, String searchValue) {
  if (searchValue.isEmpty) {
    return lockers;
  }

  List<Locker> returnLockers = <Locker>[];

  if (searchValue.length < 2) {
    returnLockers.addAll(
      lockers.where(
        (locker) => locker.floor.toLowerCase() == searchValue.toLowerCase(),
      ),
    );
  }

  if (int.tryParse(searchValue) != null) {
    returnLockers.addAll(
      lockers.where(
        (locker) =>
            locker.number.toString().contains(searchValue.toLowerCase()),
      ),
    );
  } else {
    returnLockers.addAll(
      lockers.where(
        (locker) => locker.responsible.toLowerCase().contains(
          searchValue.toLowerCase(),
        ),
      ),
    );

    if (returnLockers.isEmpty) {
      List<Student> students = StudentsRepository().fetchStudents();

      List<Student> searchStudent = [];

      searchStudent.addAll(
        students.where(
          (student) =>
              student.name.toLowerCase().contains(searchValue.toLowerCase()),
        ),
      );

      searchStudent.addAll(
        students.where(
          (student) =>
              student.surname.toLowerCase().contains(searchValue.toLowerCase()),
        ),
      );

      searchStudent = searchStudent.toSet().toList();

      for (Student student in searchStudent) {
        Locker? locker = StudentsRepository().getLockerByStudent(student.id);
        if (locker != null) {
          returnLockers.add(locker);
        }
      }
    }

    if (returnLockers.isEmpty) {
      returnLockers.addAll(
        lockers.where(
          (locker) =>
              locker.lockerCondition.comments?.toLowerCase().contains(
                searchValue,
              ) ??
              false,
        ),
      );
    }
  }

  returnLockers = returnLockers.toSet().toList();
  returnLockers.sort((a, b) => a.number - b.number);
  return returnLockers;
}

List<Locker> filterLockers(
  List<Locker> lockers, {
  String? floor,
  String? responsible,
  int? numberKeys,
  bool hasComments = false,
  bool hasProblems = false,
}) {
  List<Locker> returnLockers = lockers;

  if (floor != null) {
    returnLockers = returnLockers
        .where((locker) => locker.floor == floor)
        .toList();
  }

  if (responsible != null) {
    returnLockers = returnLockers
        .where((locker) => locker.responsible == responsible)
        .toList();
  }

  if (numberKeys != null) {
    returnLockers = returnLockers
        .where((locker) => locker.numberKeys == numberKeys)
        .toList();
  }

  if (hasComments) {
    returnLockers = returnLockers
        .where((locker) => locker.lockerCondition.comments != null)
        .toList();
  }

  if (hasProblems) {
    returnLockers = returnLockers
        .where(
          (locker) =>
              (locker.lockerCondition.problems != null ||
              locker.lockerCondition.isConditionGood == false),
        )
        .toList();
  }

  return returnLockers;
}

Locker runAutoHealthCheckOnLocker(Locker locker) {
  LockerCondition lockerCondition = locker.lockerCondition;

  if (locker.numberKeys == 0) {
    lockerCondition = lockerCondition.copyWith(
      isConditionGood: false,
      problems: 'Il n\'y a plus de clés',
    );
  } else if (locker.numberKeys == 1) {
    lockerCondition = lockerCondition.copyWith(
      isConditionGood: true,
      problems: 'Il n\'y a plus de rechanges',
    );
  }

  return locker.copyWith(lockerCondition: lockerCondition);
}

void runAutoEmptyLockerOnInvalidStudentId() {
  for (Locker lockerId in LockersRepository.lockersBox.keys) {
    Locker locker = LockersRepository.lockersBox.get(lockerId)!;

    if (locker.studentId != null &&
        !StudentsRepository.studentsBox.keys.contains(locker.studentId)) {
      locker = locker.returnFreedLocker();

      LockersRepository.lockersBox.put(lockerId, locker);
    }
  }
}

void setDemoLockersList() {
  const uuid = Uuid();
  final random = Random();
  final lockers = <Locker>[];

  int studentIndex = 0;

  for (int i = 0; i < 60; i++) {
    lockers.add(
      Locker(
        place: random.nextBool() ? 'Ancien bâtiment' : 'Nouveau bâtiment',
        floor: 'ABCDEF'[random.nextInt(6)],
        number: i + 1,
        responsible: random.nextBool() ? 'JHI' : 'PAC',
        studentId: (random.nextInt(2) != 0 && studentIndex < 40)
            ? StudentsRepository().fetchStudents()[studentIndex++].id
            : null,
        numberKeys: random.nextInt(7),
        lockNumber: random.nextInt(9000) + 1,
        lockerCondition: LockerCondition.good(),
        id: uuid.v4(),
      ),
    );
  }

  lockers[14] = lockers[14].copyWith(
    lockerCondition: const LockerCondition(
      comments: 'La 4ème clé ne fonctionne pas',
    ),
  );

  LockersRepository().importLockersFromList(lockers);
}
