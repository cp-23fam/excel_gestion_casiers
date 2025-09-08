import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid();

List<Locker> importIchFromExcelFile(Excel excel) {
  final lockers = <Locker>[];

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
      bool isLockerEmpty =
          excel[floor]
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value ==
          null;

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

      final id = uuid.v4();

      LockersRepository.instance.createStudent(
        Student(id: id, name: results[2], surname: results[3], job: results[4]),
      );

      lockers.add(
        Locker(
          floor: floor.replaceAll('Etage ', ''),
          place: place,
          number: int.parse(results[0]),
          responsible: results[1],
          studentId: !isLockerEmpty ? id : null,
          caution: int.tryParse(results[5]) ?? 0,
          numberKeys: int.parse(results[6]),
          lockNumber: int.parse(results[7]),
          lockerCondition: LockerCondition.good(
            comments: results[8] == 'null' ? null : results[8],
          ),
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

bool verifyExcelFile() {
  // TODO implement
  return true;
}
