import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/links_list/locker_link_card.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/links_list/student_link_card.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinksListScreen extends StatefulWidget {
  const LinksListScreen({super.key});

  @override
  State<LinksListScreen> createState() => _LinksListScreenState();
}

class _LinksListScreenState extends State<LinksListScreen> {
  @override
  Widget build(BuildContext context) {
    String lockerSearchQuery = '';
    String studentSearchQuery = '';
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Links'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(color: AppColors.titleColor),
                    decoration: InputDecoration(
                      labelText: 'Search by locker number'.hardcoded,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        lockerSearchQuery = value;
                      });
                    },
                  ),
                  gapH24,
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final lockersRepository = ref.watch(
                          lockersListNotifierProvider,
                        );
                        List<Locker> lockers = lockersRepository;

                        if (lockerSearchQuery.isNotEmpty) {
                          lockers = lockers.where((locker) {
                            final lockerNumberStr = locker.number.toString();
                            return lockerNumberStr.contains(lockerSearchQuery);
                          }).toList();
                        }

                        lockers.sort((a, b) => a.number.compareTo(b.number));

                        return lockers.isEmpty
                            ? Center(
                                child: StyledText(
                                  'Aucun casiers trouvé.'.hardcoded,
                                ),
                              )
                            : ListView.builder(
                                itemCount: lockers.length,
                                itemBuilder: (_, index) {
                                  final locker = lockers[index];
                                  return LockerLinkCard(
                                    locker: locker,
                                    selectLocker: (Locker locker) {},
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            gapW12,
            // const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(color: AppColors.titleColor),
                    decoration: InputDecoration(
                      labelText: 'Search by first or last name'.hardcoded,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        studentSearchQuery = value.trim().toLowerCase();
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

                        final filteredStudents = studentSearchQuery.isEmpty
                            ? students
                            : students.where((student) {
                                final firstName = student.name.toLowerCase();
                                final lastName = student.surname.toLowerCase();
                                return firstName.contains(studentSearchQuery) ||
                                    lastName.contains(studentSearchQuery);
                              }).toList();

                        filteredStudents.sort((a, b) {
                          final lastNameComp = a.surname.compareTo(b.surname);
                          if (lastNameComp != 0) return lastNameComp;
                          return a.name.compareTo(b.name);
                        });

                        return filteredStudents.isEmpty
                            ? Center(
                                child: StyledText(
                                  'Aucun étudiant trouvé.'.hardcoded,
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredStudents.length,
                                itemBuilder: (_, index) {
                                  final student = filteredStudents[index];
                                  return StudentLinkCard(
                                    student: student,
                                    selectStudent: (student) {},
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
