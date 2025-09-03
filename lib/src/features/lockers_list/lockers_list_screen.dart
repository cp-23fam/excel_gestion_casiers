import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/features/lockers_list/lockers_details_screen.dart';
import 'package:excel_gestion_casiers/src/features/providers/lockers_provder.dart';
import 'package:excel_gestion_casiers/src/models/locker.dart';
import 'package:excel_gestion_casiers/src/models/locker_condition.dart';
import 'package:excel_gestion_casiers/utils/excel.dart';
import 'package:excel_gestion_casiers/utils/lockers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockersListScreen extends StatefulWidget {
  const LockersListScreen({super.key});

  @override
  State<LockersListScreen> createState() => _LockersListScreenState();
}

class _LockersListScreenState extends State<LockersListScreen> {
  TextEditingController searchController = TextEditingController();

  void importFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes!.toList();
      if (verifyExcelFile()) {
        Excel excel = Excel.decodeBytes(bytes);
        final lockers = importIchFromExcelFile(excel);
        context.read<LockersProvder>().setLockersList(
          runAutoHealthCheckOnLockers(lockers),
        );
        context.read<LockersProvder>().createStudentListWithLockerList();
      } else {
        // TODO Show error message
      }
    }
  }

  Widget getEmptyLockersGreeting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Aucun casier...'),
          SizedBox(height: 8.0),
          TextButton(
            onPressed: importFile,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Importer un fichier excel'), Icon(Icons.add)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Locker> lockers = context.watch<LockersProvder>().lockers;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<LockersProvder>().restoreTransaction();
            },
            icon: Icon(Icons.arrow_back),
            style: IconButton.styleFrom(backgroundColor: Colors.blue),
          ),
          IconButton(
            onPressed: () {
              context.read<LockersProvder>().addLocker(
                Locker(
                  place: 'Ancien Batiment',
                  floor: 'F',
                  number: 321,
                  responsible: 'JHI',
                  student: null,
                  caution: 0,
                  numberKeys: 0,
                  lockNumber: 522678,
                  lockerCondition: LockerCondition.good(),
                ),
              );
            },
            icon: Icon(Icons.add),
            style: IconButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
      body:
          lockers.isEmpty && !context.read<LockersProvder>().getImportationDone
          ? getEmptyLockersGreeting()
          : Column(
              children: [
                Text('Casiers : ${lockers.length}'),
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    context.read<LockersProvder>().searchLocker(value);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: lockers.length,
                    itemBuilder: (context, index) => Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            LockersDetailsScreen.routeName,
                            arguments: lockers[index].number,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              lockers[index].student == null
                                  ? Icon(Icons.close, color: Colors.red)
                                  : Icon(Icons.check, color: Colors.green),
                              Text(
                                '${lockers[index].number.toString()}. ${lockers[index].student?.name ?? ''}',
                              ),
                              Expanded(child: SizedBox()),
                              lockers[index]
                                      .lockerCondition
                                      .isLockerinGoodCondition
                                  ? Icon(Icons.check, color: Colors.green)
                                  : Icon(Icons.close, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
