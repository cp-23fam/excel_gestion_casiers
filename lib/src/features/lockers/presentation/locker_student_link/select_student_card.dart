import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';

class SelectStudentCard extends StatefulWidget {
  const SelectStudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  final Student student;
  final VoidCallback onTap;

  @override
  State<SelectStudentCard> createState() => _SelectStudentCardState();
}

class _SelectStudentCardState extends State<SelectStudentCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                Expanded(child: StyledBoldText(widget.student.name)),
                gapW8,
                Expanded(child: StyledBoldText(widget.student.surname)),
                gapW8,
                Expanded(child: StyledBoldText(widget.student.job)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
