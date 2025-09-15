import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final Widget child;

  const FilterButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.isSelected,
  });
  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p8,
          horizontal: Sizes.p12,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppColors.importantColor
              : AppColors.primaryAccent,
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p24)),
        ),
        child: widget.child,
      ),
    );
  }
}
