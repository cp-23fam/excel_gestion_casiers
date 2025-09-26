import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/utils/lockers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStudentsRepository extends Mock implements StudentsRepository {}

void main() {
  late MockStudentsRepository studentsRepository;

  setUp(() {
    studentsRepository = MockStudentsRepository();
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
  ];

  group('searchInLockers', () {
    void prepareMockToReturnTwoStudentsList() {
      when(() => studentsRepository.getStudentList()).thenReturn(students);
      when(
        () => studentsRepository.getLockerByStudent('1'),
      ).thenReturn(lockers[1]);
    }

    test('Research with no value return the same list', () {
      final result = searchInLockers(lockers, '');

      expect(result, lockers);
    });

    test('Research by floor A returns two lockers', () {
      final result = searchInLockers(lockers, 'A');

      expect(result.length, 2);
    });

    test('Research by floor a (lowercase) returns two lockers', () {
      final result = searchInLockers(lockers, 'a');

      expect(result.length, 2);
    });

    test('Research by locker number 1 returns one locker', () {
      final result = searchInLockers(lockers, '1');

      expect(result.length, 1);
    });

    test('Research by responsible JHI returns three lockers', () {
      final result = searchInLockers(lockers, 'JHI');

      expect(result.length, 3);
    });

    test('Research by student Marti returns one locker', () {
      prepareMockToReturnTwoStudentsList();

      final result = searchInLockers(
        lockers,
        'Marti',
        repository: studentsRepository,
      );

      expect(result.length, 1);
    });

    test('Research by comment "4ème" returns one locker', () {
      prepareMockToReturnTwoStudentsList();

      final result = searchInLockers(
        lockers,
        '4ème',
        repository: studentsRepository,
      );

      expect(result.length, 1);
    });
  });

  group('runAutoHealthCheckOnLocker', () {
    test('A locker with more than one key is untouched', () {
      final Locker locker = Locker(
        place: 'Ancien Bâtiment',
        floor: 'C',
        number: 213,
        responsible: 'JHI',
        studentId: null,
        numberKeys: 2,
        lockNumber: 12345,
        lockerCondition: LockerCondition.good(),
        id: '1',
      );

      final result = runAutoHealthCheckOnLocker(locker);

      expect(result, locker);
    });
    test('A locker with one key return a good condition with a problem', () {
      final Locker locker = Locker(
        place: 'Ancien Bâtiment',
        floor: 'C',
        number: 213,
        responsible: 'JHI',
        studentId: null,
        numberKeys: 1,
        lockNumber: 12345,
        lockerCondition: LockerCondition.good(),
        id: '1',
      );

      final result = runAutoHealthCheckOnLocker(locker);

      expect(result.lockerCondition.isConditionGood, true);
      expect(result.lockerCondition.problems, 'Il n\'y a plus de rechanges');
    });

    test('A locker with zero keys return a bad condition with a problem', () {
      final Locker locker = Locker(
        place: 'Ancien Bâtiment',
        floor: 'C',
        number: 213,
        responsible: 'JHI',
        studentId: null,
        numberKeys: 0,
        lockNumber: 12345,
        lockerCondition: LockerCondition.good(),
        id: '1',
      );

      final result = runAutoHealthCheckOnLocker(locker);

      expect(result.lockerCondition.isConditionGood, false);
      expect(result.lockerCondition.problems, 'Il n\'y a plus de clés');
    });
  });

  group('filterLockers', () {
    test('Filter with no value return the same list', () {
      final result = filterLockers(lockers);

      expect(result, lockers);
    });

    test('Filter on floor A returns two lockers', () {
      final result = filterLockers(lockers, floor: 'A');

      expect(result.length, 2);
    });

    test('Filter on responsible JHI returns three lockers', () {
      final result = filterLockers(lockers, responsible: 'JHI');

      expect(result.length, 3);
    });

    test('Filter on number keys 2 returns one locker', () {
      final result = filterLockers(lockers, numberKeys: 2);

      expect(result.length, 1);
    });

    test('Filter on hasComments returns one locker', () {
      final result = filterLockers(lockers, hasComments: true);

      expect(result.length, 1);
    });

    test('Filter on hasProblems returns zero problems', () {
      final result = filterLockers(lockers, hasProblems: true);

      expect(result.length, 0);
    });
  });
}
