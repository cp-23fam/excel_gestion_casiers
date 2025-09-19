import 'dart:math';

import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:uuid/uuid.dart';

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

void setDemoStudentsList() {
  const uuid = Uuid();
  final random = Random();

  final names = [
    'Alexandre',
    'Benjamin',
    'Claire',
    'Diane',
    'Émile',
    'Fabian',
    'Gabriel',
    'Hugo',
    'Isabelle',
    'Julien',
    'Kévin',
    'Laura',
    'Maxime',
    'Nora',
    'Olivier',
    'Pauline',
    'Quentin',
    'Ryan',
    'Sophie',
    'Thomas',
    'Urielle',
    'Valentin',
    'Wendy',
    'Xavier',
    'Yasmine',
    'Zoé',
  ];

  final surnames = [
    'Arpello',
    'Bracello',
    'Chapuis',
    'Donzé',
    'Eronné',
    'Faure',
    'Garnier',
    'Hoft',
    'Iriny',
    'Jacquet',
    'Keller',
    'Lemoine',
    'Marti',
    'Nobs',
    'Oudin',
    'Perrin',
    'Quere',
    'Roche',
    'Samuni',
    'Thériault',
    'Ulmann',
    'Vidal',
    'Wagner',
    'Xiberras',
    'Yvon',
    'Zimmermann',
  ];

  final students = <Student>[];

  for (int i = 0; i < 45; i++) {
    students.add(
      Student(
        id: uuid.v4(),
        genderTitle: random.nextBool() ? 'M.' : 'Mme',
        name: names[random.nextInt(names.length)],
        surname: surnames[random.nextInt(surnames.length)],
        job: random.nextInt(5) == 0 ? 'OIC' : 'ICH',
        caution: random.nextBool() ? 0 : 20,
        formationYear: random.nextInt(4) + 1,
        login: 'cp-23fam',
      ),
    );
  }

  StudentsRepository().importStudentsFromList(students);
}
