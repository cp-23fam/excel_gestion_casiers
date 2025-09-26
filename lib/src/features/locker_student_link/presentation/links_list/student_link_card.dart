import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';

class StudentLinkCard extends StatefulWidget {
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
  State<StudentLinkCard> createState() => _StudentLinkCardState();
}

class _StudentLinkCardState extends State<StudentLinkCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        widget.selectStudent(widget.student);
      }),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: Card(
          color: widget.isSelected
              ? AppColors.importantColor
              : isHover
              ? AppColors.primaryAccent
              : null,
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
                    '${widget.student.genderTitle} ${widget.student.surname}',
                  ),
                ),
                gapW8,
                Expanded(child: StyledBoldText(widget.student.name)),
                gapW8,
                StyledBoldText('${widget.student.formationYear} année'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
