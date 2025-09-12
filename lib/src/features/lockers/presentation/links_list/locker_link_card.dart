import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

class LockerLinkCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectLocker(locker),
      child: Card(
        color: isSelected ? AppColors.primaryAccent : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p8,
          ),
          child: Row(
            children: [
              const Icon(Icons.door_front_door, size: Sizes.p24),
              gapW8,
              Expanded(child: StyledHeading('N° ${locker.number}')),
              gapW8,
              Expanded(child: StyledHeading('Etage ${locker.floor}')),
              gapW8,
              Expanded(
                child: StyledHeading('Responsable ${locker.responsible}'),
              ),
              // isSelected == false
              //     ? Center(child: const Icon(Icons.link_off))
              //     : Center(child: const Icon(Icons.link)),
            ],
          ),
        ),
      ),
    );
  }
}
