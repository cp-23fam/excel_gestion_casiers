import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/common_widgets/filter_dropdown.dart';
import 'package:excel_gestion_casiers/src/features/students/presentation/student_creation/student_creation_screen.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:excel_gestion_casiers/src/utils/excel.dart';
import 'package:excel_gestion_casiers/src/utils/students.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/students/presentation/students_list/student_card.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';

class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  String _searchQuery = '';
  String? selectedGenderTitle;
  String? selectedJob;
  String? selectedCaution;
  String? selectedFormationYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Élèves'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilterDropdown(
                  title: 'Genre'.hardcoded,
                  selected: selectedGenderTitle,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedGenderTitle = newValue;
                    });
                  },
                  list: <String?>[null, 'M.', 'Mme'],
                ),
                gapW24,
                FilterDropdown(
                  title: 'Métier'.hardcoded,
                  selected: selectedJob,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedJob = newValue;
                    });
                  },
                  list: <String?>[null, 'OIC', 'ICH'],
                ),
                gapW24,
                FilterDropdown(
                  title: 'Caution'.hardcoded,
                  selected: selectedCaution,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedCaution = newValue;
                    });
                  },
                  list: <String?>[null, '0', '20'],
                ),
                gapW24,
                FilterDropdown(
                  title: 'Année'.hardcoded,
                  selected: selectedFormationYear,
                  isSelected: (String? newValue) {
                    setState(() {
                      selectedFormationYear = newValue;
                    });
                  },
                  list: <String?>[null, '1', '2', '3', '4'],
                ),
                const Expanded(child: SizedBox()),
                StyledButton(
                  onPressed: () => _createStudent(),
                  child: const Icon(Icons.add, color: Colors.white, size: 30.0),
                ),
                StyledButton(
                  onPressed: () async {
                    FilePickerResult? pickedFile = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx'],
                          allowMultiple: false,
                        );

                    if (pickedFile != null) {
                      try {
                        var bytes = pickedFile.files.single.bytes!.toList();
                        var excel = Excel.decodeBytes(bytes);
                        setState(() {
                          StudentsRepository().importStudentsFromList(
                            importStudentsFrom(excel),
                          );
                        });
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.secondaryColor,
                              title: StyledTitle('Erreur'.hardcoded),
                              content: Text(
                                'Veuillez vérifier votre fichier excel'
                                    .hardcoded,
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
                      }
                    }
                  },
                  child: StyledTitle('Importer'.hardcoded),
                ),
              ],
            ),
            gapH24,
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Rechercher un étudiant'.hardcoded,
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
                    studentRepositoryProvider.notifier,
                  );
                  List<Student> students = studentsRepository.fetchStudents();
                  if (selectedGenderTitle != null) {
                    students = filterStudents(
                      students,
                      genderTitle: selectedGenderTitle!,
                    );
                  }
                  if (selectedJob != null) {
                    students = filterStudents(students, job: selectedJob!);
                  }
                  if (selectedCaution != null) {
                    students = filterStudents(
                      students,
                      caution: int.parse(selectedCaution!),
                    );
                  }
                  if (selectedFormationYear != null) {
                    students = filterStudents(
                      students,
                      formationYear: int.parse(selectedFormationYear!),
                    );
                  }

                  final filteredStudents = _searchQuery.isEmpty
                      ? students
                      : searchInStudents(students, _searchQuery);

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
                              deleteStudent: (id) => setState(() {
                                studentsRepository.deleteStudent(student.id);
                              }),
                              editStudent: (student) =>
                                  _createStudent(student: student),
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

  void _createStudent({Student? student}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Student',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StudentCreationScreen(student: student);
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
