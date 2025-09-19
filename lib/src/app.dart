import 'package:excel_gestion_casiers/src/features/home/presentation/home/home_screen.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:flutter/material.dart';

// import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
// import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
// import 'package:excel_gestion_casiers/src/utils/students.dart';
// import 'package:excel_gestion_casiers/src/utils/lockers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // if (LockersRepository().fetchLockersList().isEmpty &&
    //     StudentsRepository().fetchStudents().isEmpty) {
    //   setDemoStudentsList();
    //   setDemoLockersList();
    // }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      home: const HomeScreen(),
    );
  }
}
