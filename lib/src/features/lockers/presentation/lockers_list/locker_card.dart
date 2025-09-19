import 'package:excel_gestion_casiers/src/theme/theme.dart';
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
      surfaceTintColor: !locker.lockerCondition.isConditionGood
          ? AppColors.problemeColor
          : locker.lockerCondition.problems != null
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
            Expanded(child: StyledHeading('N° ${locker.number}')),
            gapW8,
            Expanded(child: StyledHeading('Etage ${locker.floor}')),
            gapW8,
            Expanded(child: StyledHeading('Responsable ${locker.responsible}')),
            gapW8,
            Expanded(
              child: !locker.lockerCondition.isConditionGood
                  ? Icon(Icons.error, color: AppColors.problemeColor)
                  : locker.lockerCondition.problems != null
                  ? Icon(Icons.warning, color: AppColors.warningColor)
                  : const Icon(Icons.check),
            ),
            Center(
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.importantColor,
                  ),
                ),
                hoverColor: AppColors.primaryColor,
                onPressed: () => infoLocker(locker),
                icon: Icon(Icons.double_arrow, color: AppColors.iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
