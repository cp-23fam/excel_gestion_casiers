import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/transactions/data/transaction_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/transactions/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentsRepository extends Notifier<List<Student>> {
  static final Box<Student> studentsBox = Hive.box('students');

  // Students
  void importStudentsFromList(List<Student> students) {
    studentsBox.deleteAll(studentsBox.keys);

    for (Student student in students) {
      studentsBox.put(student.id, student);
    }

    for (Locker locker in LockersRepository.lockersBox.values) {
      final studentIdInLocker = locker.studentId ?? '';
      bool willReset = true;

      for (Student student in students) {
        if (student.id == studentIdInLocker) {
          willReset = false;
          break;
        }
      }

      if (willReset) {
        LockersRepository.lockersBox.put(
          locker.number,
          locker.copyWith(studentId: null),
        );
      }
    }
  }

  List<Student> fetchNoLockerStudents() {
    final lockers = <Student>[];

    for (int i = 0; i < studentsBox.length; i++) {
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
    for (int lockerNumber in LockersRepository.lockersBox.keys) {
      final Locker locker = LockersRepository.lockersBox.get(lockerNumber)!;

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
    TransactionRepository().saveTransaction(
      TransactionType.add,
      true,
      studentValue: student,
    );

    studentsBox.put(student.id, student);
  }

  void editStudent(Student editedStudent) {
    TransactionRepository().saveTransaction(
      TransactionType.edit,
      true,
      studentValue: studentsBox.get(editedStudent.id),
    );

    studentsBox.put(editedStudent.id, editedStudent);
  }

  void deleteStudent(String id) {
    TransactionRepository().saveTransaction(
      TransactionType.remove,
      true,
      studentValue: studentsBox.get(id)!,
    );

    studentsBox.delete(id);
  }

  @override
  build() {
    return [];
  }
}

final studentRepositoryProvider =
    NotifierProvider<StudentsRepository, List<Student>>(() {
      return StudentsRepository();
    });
