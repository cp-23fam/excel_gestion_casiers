import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';

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
      List<Student> students = LockersRepository().fetchStudents();

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
        Locker? locker = LockersRepository().getLockerByStudent(student.id);
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
