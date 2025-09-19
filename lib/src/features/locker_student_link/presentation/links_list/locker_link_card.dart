import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

class LockerLinkCard extends StatefulWidget {
  final Locker locker;
  final void Function(Locker) selectLocker;
  final bool isSelected;

  const LockerLinkCard({
    super.key,
    required this.locker,
    required this.selectLocker,
    required this.isSelected,
  });

  @override
  State<LockerLinkCard> createState() => _LockerLinkCardState();
}

class _LockerLinkCardState extends State<LockerLinkCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.selectLocker(widget.locker),
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
                const Icon(Icons.door_front_door, size: Sizes.p24),
                gapW8,
                Expanded(child: StyledHeading('N° ${widget.locker.number}')),
                gapW8,
                Expanded(child: StyledHeading('Etage ${widget.locker.floor}')),
                gapW8,
                Expanded(
                  child: StyledHeading(
                    'Responsable ${widget.locker.responsible}',
                  ),
                ),
                // isSelected == false
                //     ? Center(child: const Icon(Icons.link_off))
                //     : Center(child: const Icon(Icons.link)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
