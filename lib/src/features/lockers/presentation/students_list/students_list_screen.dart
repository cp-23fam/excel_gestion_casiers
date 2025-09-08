import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
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
  String _searchQuery = '';

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
                  child: const Icon(Icons.add, color: Colors.white, size: 30.0),
                ),
                StyledButton(
                  onPressed: () {},
                  child: StyledTitle('Import'.hardcoded),
                ),
              ],
            ),
            gapH24,
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Search by first or last name'.hardcoded,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
            gapH24,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final studentsRepository = ref.watch(
                    lockersRepositoryProvider,
                  );
                  final students = studentsRepository.fetchStudents();

                  final filteredStudents = _searchQuery.isEmpty
                      ? students
                      : students.where((student) {
                          final firstName = student.name.toLowerCase();
                          final lastName = student.surname.toLowerCase();
                          return firstName.contains(_searchQuery) ||
                              lastName.contains(_searchQuery);
                        }).toList();

                  filteredStudents.sort((a, b) {
                    final lastNameComp = a.surname.compareTo(b.surname);
                    if (lastNameComp != 0) return lastNameComp;
                    return a.name.compareTo(b.name);
                  });

                  return filteredStudents.isEmpty
                      ? Center(
                          child: StyledText('Aucun étudiant trouvé.'.hardcoded),
                        )
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (_, index) {
                            final student = filteredStudents[index];
                            return StudentCard(
                              student: student,
                              deleteStudent: (id) => deleteStudent(student.id),
                            );
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

  void deleteStudent(String id) {
    final studentsRepository = ref.read(lockersRepositoryProvider);
    studentsRepository.erazeStudentBy(id);
  }
}
