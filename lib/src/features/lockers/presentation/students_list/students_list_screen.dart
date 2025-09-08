import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/students_list/student_card.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';

class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Students'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StyledButton(
                  onPressed: () {},
                  child: Icon(Icons.add, color: Colors.white, size: 30.0),
                ),
                StyledButton(onPressed: () {}, child: StyledTitle('Import')),
              ],
            ),
            gapH24,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final studentsRepository = ref.watch(
                    lockersRepositoryProvider,
                  );
                  final students = studentsRepository.fetchStudents();
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (_, index) {
                      final student = students[index];
                      return StudentCard(student: student);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
