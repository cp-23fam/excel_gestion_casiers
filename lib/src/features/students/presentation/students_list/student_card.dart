import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';

class StudentCard extends StatefulWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.deleteStudent,
    required this.editStudent,
  });
  final Student student;
  final Function(String) deleteStudent;
  final Function(Student student) editStudent;

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        color: isHover ? AppColors.primaryAccent : null,
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
                  '${widget.student.genderTitle} ${widget.student.name}',
                ),
              ),
              gapW8,
              Expanded(child: StyledBoldText(widget.student.surname)),
              gapW8,
              Expanded(child: StyledBoldText(widget.student.job)),
              gapW8,
              Expanded(
                child: StyledBoldText('${widget.student.formationYear} année'),
              ),
              gapW8,
              Expanded(child: StyledBoldText(widget.student.login)),
              isHover
                  ? Row(
                      children: [
                        Center(
                          child: IconButton(
                            onPressed: () => widget.editStudent(widget.student),
                            icon: Icon(Icons.edit, color: AppColors.editColor),
                          ),
                        ),
                        Center(
                          child: IconButton(
                            onPressed: () =>
                                widget.deleteStudent(widget.student.id),
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.deleteColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(height: Sizes.p48, width: Sizes.p96),
            ],
          ),
        ),
      ),
    );
  }
}
