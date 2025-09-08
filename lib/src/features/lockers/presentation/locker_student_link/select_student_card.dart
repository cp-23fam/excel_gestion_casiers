import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';

class SelectStudentCard extends StatelessWidget {
  const SelectStudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p8,
          ),
          child: Row(
            children: [
              const Icon(Icons.person, size: Sizes.p24),
              gapW8,
              Expanded(child: StyledBoldText(student.name)),
              gapW8,
              Expanded(child: StyledBoldText(student.surname)),
              gapW8,
              Expanded(child: StyledBoldText(student.job)),
            ],
          ),
        ),
      ),
    );
  }
}
