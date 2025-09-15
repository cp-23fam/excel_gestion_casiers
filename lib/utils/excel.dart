import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

List<Locker> importLockersFrom(Excel excel) {
  final lockers = <Locker>[];

  if (!excel.sheets.keys.contains('Etage')) {
    throw Error();
  }

  for (final floor in excel.sheets.keys.where((key) => key.contains('Etage'))) {
    if (!['Etage B', 'Etage C', 'Etage D', 'Etage E'].contains(floor)) {
      continue;
    }

    String place = excel[floor]
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        .value
        .toString();

    int row = 1;

    if (floor == 'Etage B') {
      row = 81;
    }

    if (floor == 'Etage E') {
      row = 44;
    }

    var cell = excel[floor].cell(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row),
    );
    while (cell.value != null) {
      final results = [];
      for (int i = 0; i < 9; i++) {
        var cell = excel[floor].cell(
          CellIndex.indexByColumnRow(columnIndex: 2 + i, rowIndex: row),
        );

        results.add(cell.value.toString());
      }

      if (results[3] == 'null') {
        cell = excel[floor].cell(
          CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: ++row),
        );
        continue;
      }

      String id = '';

      for (dynamic studentId in StudentsRepository.studentsBox.keys) {
        Student student = StudentsRepository.studentsBox.get(studentId)!;

        if (student.surname == results[3] && student.name == results[4]) {
          id = studentId;
          StudentsRepository.studentsBox.put(
            id,
            student.copyWith(caution: int.tryParse(results[5]) ?? 0),
          );
        }
      }

      lockers.add(
        Locker(
          floor: floor.replaceAll('Etage ', ''),
          place: place,
          number: int.parse(results[0]),
          responsible: results[1],
          studentId: id == '' ? null : id,
          numberKeys: int.parse(results[6]),
          lockNumber: int.parse(results[7]),
          lockerCondition: LockerCondition.good(
            comments: results[8] == 'null' ? null : results[8],
          ),
          id: uuid.v4(),
        ),
      );

      cell = excel[floor].cell(
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: ++row),
      );
    }
  }

  lockers.sort((a, b) => a.number - b.number);

  return lockers;
}

List<Student> importStudentsFrom(Excel excel) {
  final students = <Student>[];

  final sheet = excel[excel.sheets.keys.first];

  if (sheet.sheetName != 'ESMA-Export') {
    throw Error();
  }

  var cell = sheet.cell(CellIndex.indexByString('A1'));
  int row = 1;

  while (cell.value != null) {
    final results = [];
    for (int i = 0; i < 25; i++) {
      results.add(cell.value?.toString() ?? '');
      cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: row),
      );
    }

    students.add(
      Student(
        id: uuid.v4(),
        name: results[7],
        genderTitle: results[5],
        surname: results[6],
        login: results[12],
        formationYear: int.parse(results[19]),
        job: results[14],
        caution: 20,
      ),
    );

    cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: ++row),
    );
  }

  return students;
}
