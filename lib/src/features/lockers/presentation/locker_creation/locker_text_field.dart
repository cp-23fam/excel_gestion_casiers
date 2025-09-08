import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:google_fonts/google_fonts.dart';

class LockerTextField extends StatelessWidget {
  const LockerTextField({
    required this.controller,
    required this.text,
    required this.icon,
    this.validator,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String text;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.textColor,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        label: StyledText(text.hardcoded),
      ),
      style: GoogleFonts.kanit(
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
