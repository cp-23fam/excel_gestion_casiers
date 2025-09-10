import 'package:excel_gestion_casiers/src/app.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Adapters
  Hive.registerAdapter(LockerAdapter());
  Hive.registerAdapter(LockerConditionAdapter());
  Hive.registerAdapter(StudentAdapter());

  // Boxes
  await Hive.openBox<Locker>('lockers');
  await Hive.openBox<Student>('students');

  // await Hive.deleteBoxFromDisk('lockers');
  // await Hive.deleteBoxFromDisk('students');

  runApp(const ProviderScope(child: MyApp()));
}
