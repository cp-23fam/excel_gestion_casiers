import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/links_list/locker_link_card.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/links_list/student_link_card.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:excel_gestion_casiers/utils/lockers.dart';
import 'package:excel_gestion_casiers/utils/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinksListScreen extends ConsumerStatefulWidget {
  const LinksListScreen({super.key});

  @override
  ConsumerState<LinksListScreen> createState() => _LinksListScreenState();
}

class _LinksListScreenState extends ConsumerState<LinksListScreen> {
  String lockerSearchQuery = '';
  String studentSearchQuery = '';
  Locker? selectedLocker;
  Student? selectedStudent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Links'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StyledButton(
                  onPressed: () {
                    if (selectedLocker != null && selectedStudent != null) {
                      LockersRepository().editLocker(
                        selectedLocker!.number,
                        selectedLocker!.copyWith(
                          studentId: selectedStudent!.id,
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.link,
                    color: AppColors.iconColor,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            gapH12,
            Expanded(
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
                                lockersRepositoryProvider.notifier,
                              );
                              List<Locker> lockers = lockersRepository
                                  .fetchFreeLockers();

                              if (lockerSearchQuery.isNotEmpty) {
                                lockers = searchInLockers(
                                  lockers,
                                  lockerSearchQuery,
                                );
                              }

                              lockers.sort(
                                (a, b) => a.number.compareTo(b.number),
                              );

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
                                          selectLocker: (Locker locker) {
                                            setState(() {
                                              if (selectedLocker == locker) {
                                                selectedLocker = null;
                                              } else {
                                                selectedLocker = locker;
                                              }
                                            });
                                          },
                                          isSelected: locker == selectedLocker,
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
                                studentRepositoryProvider.notifier,
                              );
                              final students = studentsRepository
                                  .fetchNoLockerStudents();

                              final filteredStudents =
                                  studentSearchQuery.isEmpty
                                  ? students
                                  : searchInStudents(
                                      students,
                                      studentSearchQuery,
                                    );

                              filteredStudents.sort((a, b) {
                                final lastNameComp = a.surname.compareTo(
                                  b.surname,
                                );
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
                                          selectStudent: (Student student) {
                                            setState(() {
                                              if (selectedStudent == student) {
                                                selectedStudent = null;
                                              } else {
                                                selectedStudent = student;
                                              }
                                            });
                                          },
                                          isSelected:
                                              student == selectedStudent,
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
          ],
        ),
      ),
    );
  }

  void linkOn(Locker locker, Student student) {
    LockersRepository().editLocker(
      locker.lockNumber,
      locker.copyWith(studentId: student.id),
    );
  }
}
