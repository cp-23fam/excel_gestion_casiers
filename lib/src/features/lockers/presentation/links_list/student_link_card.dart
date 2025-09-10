import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';

class StudentLinkCard extends StatelessWidget {
  const StudentLinkCard({
    super.key,
    required this.student,
    required this.selectStudent,
  });
  final Student student;
  final Function(Student student) selectStudent;

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
            gapW8,
            Expanded(
              child: StyledBoldText('${student.genderTitle} ${student.name}'),
            ),
            gapW8,
            Expanded(child: StyledBoldText(student.surname)),
            gapW8,
            Expanded(child: StyledBoldText(student.job)),
            gapW8,
            Expanded(child: StyledBoldText('${student.formationYear} année')),
            gapW8,
            Expanded(child: StyledBoldText(student.login)),
            Center(
              child: IconButton(
                onPressed: () => selectStudent(student),
                icon: const Icon(Icons.link_off),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
