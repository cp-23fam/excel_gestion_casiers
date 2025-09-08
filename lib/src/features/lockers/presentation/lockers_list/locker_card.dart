import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

class LockerCard extends StatelessWidget {
  const LockerCard({super.key, required this.locker, required this.infoLocker});
  final Locker locker;
  final Function(Locker locker) infoLocker;

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
            const Icon(Icons.door_front_door, size: Sizes.p24),
            gapW8,
            Expanded(child: StyledHeading('N° ${locker.number}')),
            gapW8,
            Expanded(child: StyledHeading('Etage ${locker.floor}')),
            gapW8,
            Expanded(child: StyledHeading('Responsable ${locker.responsible}')),
            gapW8,
            Expanded(
              child: StyledHeading(locker.lockerCondition.comments ?? '-'),
            ),
            Center(
              child: IconButton(
                onPressed: () => infoLocker(locker),
                icon: const Icon(Icons.double_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
