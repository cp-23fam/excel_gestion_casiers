import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_student_link/select_student_card.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';

class LockerStudentLinkScreen extends ConsumerStatefulWidget {
  const LockerStudentLinkScreen({
    super.key,
    required this.locker,
    required this.onStudentLinked,
  });

  final Locker locker;
  final VoidCallback onStudentLinked;

  @override
  ConsumerState<LockerStudentLinkScreen> createState() =>
      _LockerStudentLinkScreenState();
}

class _LockerStudentLinkScreenState
    extends ConsumerState<LockerStudentLinkScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsRepository = ref.watch(studentRepositoryProvider.notifier);
    final allStudents = studentsRepository.fetchStudents();

    final filteredStudents = allStudents.where((student) {
      final fullName = '${student.name} ${student.surname}'.toLowerCase();
      return fullName.contains(_searchText);
    }).toList();

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(title: const StyledTitle('Sélectionner un étudiant')),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.titleColor),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou prénom'.hardcoded,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.p8),
                    ),
                  ),
                ),
                gapH16,
                Expanded(
                  child: filteredStudents.isEmpty
                      ? Center(
                          child: StyledText('Aucun étudiant trouvé.'.hardcoded),
                        )
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (_, index) {
                            final student = filteredStudents[index];
                            return SelectStudentCard(
                              student: student,
                              onTap: () {
                                ref
                                    .read(lockersRepositoryProvider.notifier)
                                    .editLocker(
                                      widget.locker.number,
                                      widget.locker.copyWith(
                                        studentId: student.id,
                                      ),
                                    );

                                widget.onStudentLinked();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
