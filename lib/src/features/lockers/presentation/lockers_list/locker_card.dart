import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

class LockerCard extends StatefulWidget {
  const LockerCard({
    super.key,
    required this.locker,
    required this.student,
    required this.infoLocker,
  });
  final Locker locker;
  final Student? student;
  final Function(Locker locker) infoLocker;

  @override
  State<LockerCard> createState() => _LockerCardState();
}

class _LockerCardState extends State<LockerCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.infoLocker(widget.locker),
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
          surfaceTintColor: !widget.locker.lockerCondition.isConditionGood
              ? AppColors.problemeColor
              : widget.locker.lockerCondition.problems != null
              ? AppColors.warningColor
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p8,
            ),
            child: Row(
              children: [
                const Icon(Icons.door_front_door, size: Sizes.p24),
                gapW8,
                Expanded(
                  child: StyledHeading('N° ${widget.locker.number}'.hardcoded),
                ),
                gapW8,
                Expanded(
                  child: StyledHeading(
                    'Etage ${widget.locker.floor}'.hardcoded,
                  ),
                ),
                gapW8,
                Expanded(
                  child: StyledHeading(
                    'Responsable ${widget.locker.responsible}'.hardcoded,
                  ),
                ),
                gapW8,
                Expanded(
                  child: !widget.locker.lockerCondition.isConditionGood
                      ? Icon(Icons.error, color: AppColors.problemeColor)
                      : widget.locker.lockerCondition.problems != null
                      ? Icon(Icons.warning, color: AppColors.warningColor)
                      : const Icon(Icons.check),
                ),
                gapW8,
                widget.student == null
                    ? const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [StyledBoldText('-')],
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.person, size: Sizes.p24),
                              gapW8,
                              StyledBoldText(widget.student!.name),
                              gapW8,
                              StyledBoldText(widget.student!.surname),
                            ],
                          ),
                        ),
                      ),
                // Center(
                //   child: IconButton(
                //     style: ButtonStyle(
                //       backgroundColor: WidgetStateProperty.all<Color>(
                //         AppColors.importantColor,
                //       ),
                //     ),
                //     hoverColor: AppColors.primaryColor,
                //     onPressed: () => widget.infoLocker(widget.locker),
                //     icon: Icon(Icons.double_arrow, color: AppColors.iconColor),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
