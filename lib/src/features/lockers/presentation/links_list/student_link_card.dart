import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';

class StudentLinkCard extends StatelessWidget {
  const StudentLinkCard({
    super.key,
    required this.student,
    required this.selectStudent,
    required this.isSelected,
  });
  final Student student;
  final Function(Student student) selectStudent;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Locker? possedLocker = LockersRepository().getLockerByStudent(student.id);
    return GestureDetector(
      onTap: () => selectStudent(student),
      child: Card(
        color: isSelected ? AppColors.primaryAccent : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p8,
          ),
          child: Row(
            children: [
              const Icon(Icons.person, size: Sizes.p24),
              gapW8,
              Expanded(
                child: StyledBoldText(
                  '${student.genderTitle} ${student.surname}',
                ),
              ),
              gapW8,
              Expanded(child: StyledBoldText(student.name)),
              gapW8,
              possedLocker == null
                  ? const Expanded(child: StyledBoldText('-'))
                  : Expanded(
                      child: StyledBoldText('Casier N° ${possedLocker.number}'),
                    ),
              // gapW8,
              // Expanded(child: StyledBoldText('${student.formationYear} année')),
              // gapW8,
              // Expanded(child: StyledBoldText(student.login)),
              possedLocker == null
                  ? const SizedBox(height: Sizes.p48, width: Sizes.p48)
                  : Center(
                      child: IconButton(
                        onPressed: () {
                          selectStudent(student);
                          // studentsRepository.freeLockerByIndex(locker.number);
                        },
                        icon: const Icon(Icons.link_off),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
