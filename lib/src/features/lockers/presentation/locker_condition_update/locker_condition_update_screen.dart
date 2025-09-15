import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_creation/locker_text_field.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

class LockerConditionUpdateScreen extends ConsumerStatefulWidget {
  final Locker locker;

  const LockerConditionUpdateScreen({super.key, required this.locker});

  @override
  ConsumerState<LockerConditionUpdateScreen> createState() =>
      _LockerConditionUpdateScreenState();
}

class _LockerConditionUpdateScreenState
    extends ConsumerState<LockerConditionUpdateScreen> {
  late bool _isConditionGood;
  late final TextEditingController _problemsController;
  late final TextEditingController _commentsController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cond = widget.locker.lockerCondition;
    _isConditionGood = cond.isConditionGood;
    _problemsController = TextEditingController(text: cond.problems ?? '');
    _commentsController = TextEditingController(text: cond.comments ?? '');
  }

  @override
  void dispose() {
    _problemsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newCondition = LockerCondition(
        isConditionGood: _isConditionGood,
        problems: _problemsController.text.trim().isEmpty
            ? null
            : _problemsController.text.trim(),
        comments: _commentsController.text.trim().isEmpty
            ? null
            : _commentsController.text.trim(),
      );

      final notifier = ref.read(lockersRepositoryProvider.notifier);

      final updatedLocker = widget.locker.copyWith(
        lockerCondition: newCondition,
      );

      notifier.editLocker(widget.locker.number, updatedLocker);

      Navigator.of(context).pop();
    }
  }

  String? _validateOptionalText(String? value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: const StyledTitle('Modifier la condition du casier'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p20,
              vertical: Sizes.p32,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const StyledHeading('Casier en bon état'),
                    value: _isConditionGood,
                    onChanged: (val) {
                      setState(() {
                        _isConditionGood = val;
                      });
                    },
                  ),
                  gapH20,
                  LockerTextField(
                    controller: _problemsController,
                    text: 'Problème',
                    icon: Icons.dangerous,
                    validator: _validateOptionalText,
                  ),
                  gapH20,
                  TextFormField(
                    controller: _commentsController,
                    maxLines: 3,
                    style: TextStyle(color: AppColors.textColor),
                    decoration: const InputDecoration(
                      labelText: 'Commentaires',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateOptionalText,
                  ),
                  gapH32,
                  Center(
                    child: StyledButton(
                      onPressed: handleSubmit,
                      child: const StyledHeading('Enregistrer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
