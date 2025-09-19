import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({
    super.key,
    required this.selected,
    required this.isSelected,
    required this.list,
    required this.title,
  });
  final List<String?> list;
  final String? selected;
  final Function(String? newValue) isSelected;
  final String title;

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StyledTitle('${widget.title} :'),
        gapW12,
        DropdownButton<String>(
          value: widget.selected,
          hint: const StyledText('Filtrer par responsable'),
          dropdownColor: AppColors.secondaryColor,
          style: TextStyle(color: AppColors.titleColor),
          underline: const SizedBox(),
          items: widget.list.map((String? responsible) {
            return DropdownMenuItem<String>(
              value: responsible,
              child: StyledText(responsible ?? 'Tous'),
            );
          }).toList(),
          onChanged: widget.isSelected,
        ),
      ],
    );
  }
}
