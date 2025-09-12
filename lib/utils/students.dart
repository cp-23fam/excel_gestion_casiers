import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';

List<Student> searchInStudents(List<Student> students, String searchValue) {
  if (searchValue.isEmpty) {
    return students;
  }

  List<Student> returnStudents = <Student>[];

  if (int.tryParse(searchValue) != null) {
    List<Locker> lockers = LockersRepository().fetchLockersList();

    for (Locker locker in lockers) {
      if (locker.studentId == null) {
        continue;
      }

      if (locker.number.toString().toLowerCase().contains(
        searchValue.toLowerCase(),
      )) {
        Student student = LockersRepository().getStudentByLocker(
          locker.number,
        )!;

        returnStudents.add(student);
      }
    }
  } else {
    returnStudents.addAll(
      students.where(
        (student) =>
            student.name.toLowerCase().contains(searchValue.toLowerCase()),
      ),
    );

    returnStudents.addAll(
      students.where(
        (student) =>
            student.surname.toLowerCase().contains(searchValue.toLowerCase()),
      ),
    );
  }

  returnStudents = returnStudents.toSet().toList();
  returnStudents.sort((a, b) => a.surname.compareTo(b.surname));

  return returnStudents;
}

List<Student> filterStudents(
  List<Student> students, {
  String? genderTitle,
  String? job,
  int? caution,
  int? formationYear,
}) {
  List<Student> returnStudents = students;

  if (genderTitle != null) {
    returnStudents = returnStudents
        .where((student) => student.genderTitle == genderTitle)
        .toList();
  }

  if (job != null) {
    returnStudents = returnStudents
        .where((student) => student.job == job)
        .toList();
  }

  if (caution != null) {
    returnStudents = returnStudents
        .where((student) => student.caution == caution)
        .toList();
  }

  if (formationYear != null) {
    returnStudents = returnStudents
        .where((student) => student.formationYear == formationYear)
        .toList();
  }

  return returnStudents;
}
