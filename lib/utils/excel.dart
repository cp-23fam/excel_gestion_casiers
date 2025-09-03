import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/models/locker.dart';
import 'package:excel_gestion_casiers/src/models/locker_condition.dart';
import 'package:excel_gestion_casiers/src/models/student.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

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
      for (int i = 0; i < 8; i++) {
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

      lockers.add(
        Locker(
          floor: floor.replaceAll('Etage ', ''),
          place: place,
          number: int.parse(results[0]),
          responsible: results[1],
          student: !isLockerEmpty
              ? Student(
                  job: results[2],
                  name: results[3],
                  surname: results[4],
                  id: uuid.v4(),
                )
              : null,
          caution: int.tryParse(results[5]) ?? 0,
          numberKeys: int.parse(results[6]),
          lockNumber: int.parse(results[7]),
          lockerCondition: LockerCondition.good(),
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
