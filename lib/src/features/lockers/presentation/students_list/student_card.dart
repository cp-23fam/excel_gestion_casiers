import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.deleteStudent,
  });
  final Student student;
  final Function(String) deleteStudent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p8,
        ),
        child: Row(
          children: [
            const Icon(Icons.person, size: Sizes.p24),
            const Icon(Icons.person, size: Sizes.p24),
            gapW8,
            Expanded(child: StyledBoldText(student.name)),
            gapW8,
            Expanded(child: StyledBoldText(student.surname)),
            gapW8,
            Expanded(child: StyledBoldText(student.job)),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, color: AppColors.editColor),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () => deleteStudent(student.id),
                icon: Icon(Icons.delete, color: AppColors.deleteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
