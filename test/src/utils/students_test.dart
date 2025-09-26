import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/utils/students.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLockersRepository extends Mock implements LockersRepository {}

void main() {
  late MockLockersRepository lockersRepository;

  setUp(() {
    lockersRepository = MockLockersRepository();
  });

  final lockers = [
    Locker(
      place: 'Ancien Bâtiment',
      floor: 'A',
      number: 1,
      responsible: 'JHI',
      studentId: null,
      numberKeys: 2,
      lockNumber: 12345,
      lockerCondition: const LockerCondition(
        comments: 'La 4ème clé ne fonctionne pas',
      ),
      id: '1',
    ),
    Locker(
      place: 'Ancien Bâtiment',
      floor: 'A',
      number: 2,
      responsible: 'JHI',
      studentId: '1',
      numberKeys: 5,
      lockNumber: 25565,
      lockerCondition: LockerCondition.good(),
      id: '2',
    ),
    Locker(
      place: 'Ancien Bâtiment',
      floor: 'B',
      number: 3,
      responsible: 'JHI',
      studentId: null,
      numberKeys: 3,
      lockNumber: 123456,
      lockerCondition: LockerCondition.good(),
      id: '3',
    ),
  ];

  final students = [
    const Student(
      id: '1',
      genderTitle: 'M.',
      name: 'Fabian',
      surname: 'Marti',
      job: 'ICH',
      caution: 20,
      formationYear: 2,
      login: 'cp-23fam',
    ),
    const Student(
      id: '2',
      genderTitle: 'Mme',
      name: 'Sophie',
      surname: 'Hubler',
      job: 'ICH',
      caution: 0,
      formationYear: 1,
      login: 'cp-24soh',
    ),
    const Student(
      id: '3',
      genderTitle: 'M.',
      name: 'Ryan',
      surname: 'Donzé',
      job: 'OIC',
      caution: 20,
      formationYear: 2,
      login: 'cp-23ryd',
    ),
  ];

  group('SearchInStudents', () {
    void prepareMockToReturnThreeLockersList() {
      when(() => lockersRepository.getLockersList()).thenReturn(lockers);
      when(
        () => lockersRepository.getStudentByLocker(2),
      ).thenReturn(students[0]);
    }

    test('Research with no value returns the same list', () {
      final result = searchInStudents(students, '');

      expect(result, students);
    });

    test('Research of 2 returns one student', () {
      prepareMockToReturnThreeLockersList();

      final result = searchInStudents(
        students,
        '2',
        repository: lockersRepository,
      );

      expect(result.length, 1);
    });

    test('Research of a returns two students', () {
      final result = searchInStudents(students, 'a');

      expect(result.length, 2);
    });
  });

  group('filterStudents', () {
    test('Filter with no value return the same list', () {
      final result = filterStudents(students);

      expect(result, students);
    });

    test('Filter by gender Mme returns one student', () {
      final result = filterStudents(students, genderTitle: 'Mme');

      expect(result.length, 1);
    });

    test('Filter by job OIC returns one student', () {
      final result = filterStudents(students, job: 'OIC');

      expect(result.length, 1);
    });

    test('Filter by caution 20 returns two student', () {
      final result = filterStudents(students, caution: 20);

      expect(result.length, 2);
    });

    test('Filter by formationYear 1 returns one student', () {
      final result = filterStudents(students, formationYear: 1);

      expect(result.length, 1);
    });
  });
}
