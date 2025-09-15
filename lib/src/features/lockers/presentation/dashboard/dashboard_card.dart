import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.text,
    required this.comment,
    required this.condition,
    this.logo,
    this.value,
    super.key,
  });

  final String text;
  final String comment;
  final int condition;
  final IconData? logo;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 8.0,
        children: [
          Row(
            children: [
              Icon(logo ?? Icons.circle_outlined, size: 48.0),
              StyledHeading(text),
            ],
          ),
          LinearProgressIndicator(
            value: value ?? 0,
            backgroundColor: AppColors.primaryAccent,
            color: AppColors.iconColor,
          ),
          Row(
            spacing: 8.0,
            children: [
              condition == 0
                  ? Icon(Icons.check_box, color: AppColors.goodColor)
                  : condition == 1
                  ? Icon(Icons.warning, color: AppColors.importantColor)
                  : Icon(Icons.error, color: AppColors.deleteColor),
              Text(comment),
            ],
          ),

          StyledText('Last check : 00:00:00'),
        ],
      ),
    );
  }
}
