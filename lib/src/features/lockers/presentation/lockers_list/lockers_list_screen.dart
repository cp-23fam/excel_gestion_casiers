import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/filter/filter_button.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/filter/filter_dropdown.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_condition_update/locker_condition_update_screen.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:excel_gestion_casiers/utils/excel.dart';
import 'package:excel_gestion_casiers/utils/lockers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_creation/locker_creation_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_profile/locker_profile_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_student_link/locker_student_link_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/lockers_list/locker_card.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';

class LockersListScreen extends ConsumerStatefulWidget {
  const LockersListScreen({super.key});

  @override
  ConsumerState<LockersListScreen> createState() => _LockersListScreenState();
}

class _LockersListScreenState extends ConsumerState<LockersListScreen> {
  String _searchQuery = '';
  String filter = 'number';
  String? selectedFloor;
  String? selectedResponsible;
  bool hasComments = false;
  bool hasProblems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Lockers'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilterDropdown(
                  title: 'Floor',
                  selected: selectedFloor,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedFloor = newValue;
                    });
                  },
                  list: <String?>[null, 'A', 'B', 'C', 'D', 'E'],
                ),
                gapW24,
                FilterDropdown(
                  title: 'Responsible',
                  selected: selectedResponsible,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedResponsible = newValue;
                    });
                  },
                  list: <String?>[null, 'JHI', 'PAC'],
                ),
                gapW24,
                FilterButton(
                  onPressed: () {
                    setState(() {
                      if (hasComments) {
                        hasComments = false;
                      } else {
                        hasComments = true;
                      }
                    });
                  },
                  isSelected: hasComments,
                  child: const StyledTitle('has Comments'),
                ),
                FilterButton(
                  onPressed: () {
                    setState(() {
                      if (hasProblems) {
                        hasProblems = false;
                      } else {
                        hasProblems = true;
                      }
                    });
                  },
                  isSelected: hasProblems,
                  child: const StyledTitle('has Problems'),
                ),
                const Expanded(child: SizedBox()),
                StyledButton(
                  onPressed: () => _createLocker(),
                  child: Icon(
                    Icons.add,
                    color: AppColors.iconColor,
                    size: 30.0,
                  ),
                ),
                StyledButton(
                  onPressed: () async {
                    List<Student> students = StudentsRepository()
                        .fetchStudents();
                    if (students.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.secondaryColor,
                            title: const StyledTitle('Erreur'),
                            content: const Text(
                              'Aucun étudiant trouvé. Veuillez importer les données des étudiants avant.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      FilePickerResult? pickedFile = await FilePicker.platform
                          .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                            allowMultiple: false,
                          );

                      if (pickedFile != null) {
                        var bytes = pickedFile.files.single.bytes!.toList();
                        var excel = Excel.decodeBytes(bytes);
                        setState(() {
                          LockersRepository().importLockersFromList(
                            importLockersFrom(excel),
                          );
                        });
                      }
                    }
                  },
                  child: StyledTitle('Import'.hardcoded),
                ),
              ],
            ),
            gapH24,
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Search by locker number'.hardcoded,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
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
                  List<Locker> lockers = lockersRepository.fetchLockersList();
                  if (selectedFloor != null) {
                    lockers = filterLockers(lockers, floor: selectedFloor!);
                  }

                  if (selectedResponsible != null) {
                    lockers = filterLockers(
                      lockers,
                      responsible: selectedResponsible!,
                    );
                  }

                  if (hasComments) {
                    lockers = filterLockers(lockers, hasComments: true);
                  }

                  if (hasProblems) {
                    lockers = filterLockers(lockers, hasProblems: true);
                  }

                  if (_searchQuery.isNotEmpty) {
                    lockers = searchInLockers(lockers, _searchQuery);
                  }

                  lockers.sort((a, b) => a.number.compareTo(b.number));

                  return lockers.isEmpty
                      ? Center(
                          child: StyledText('Aucun casiers trouvé.'.hardcoded),
                        )
                      : ListView.builder(
                          itemCount: lockers.length,
                          itemBuilder: (_, index) {
                            final locker = lockers[index];
                            return LockerCard(
                              locker: locker,
                              infoLocker: (locker) =>
                                  _infoLocker(locker: locker),
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

  void _infoLocker({Locker? locker}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Locker Info',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LockerProfileScreen(
          lockerId: locker!.id,
          editLocker: (locker) => _createLocker(locker: locker),
          linkStudent: (locker) => _selectStudent(locker: locker),
          editLockerCondition: (locker) => _editLockerCondition(locker: locker),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        );
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }

  void _createLocker({Locker? locker}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Locker',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LockerCreationScreen(locker: locker);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        );
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }

  void _selectStudent({required Locker locker}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Select Student',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LockerStudentLinkScreen(
          locker: locker,
          onStudentLinked: () {
            setState(() {});
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        );
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }

  void _editLockerCondition({required Locker locker}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Select Student',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LockerConditionUpdateScreen(locker: locker);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        );
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }
}
