import 'package:excel_gestion_casiers/src/features/lockers/domain/locker_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_creation/locker_text_field.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class LockerCreationScreen extends ConsumerStatefulWidget {
  final Locker? locker; // locker optionnel

  const LockerCreationScreen({super.key, this.locker});

  @override
  ConsumerState<LockerCreationScreen> createState() =>
      _LockerCreationScreenState();
}

class _LockerCreationScreenState extends ConsumerState<LockerCreationScreen> {
  late final TextEditingController _numberController;
  late final TextEditingController _floorController;
  late final TextEditingController _responsibleController;
  late final TextEditingController _numberKeysController;
  late final TextEditingController _lockNumberController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialiser les controllers, avec les valeurs existantes si on modifie
    _numberController = TextEditingController(
      text: widget.locker?.number.toString() ?? '',
    );
    _floorController = TextEditingController(text: widget.locker?.floor ?? '');
    _responsibleController = TextEditingController(
      text: widget.locker?.responsible ?? '',
    );
    _numberKeysController = TextEditingController(
      text: widget.locker?.numberKeys.toString() ?? '',
    );
    _lockNumberController = TextEditingController(
      text: widget.locker?.lockNumber.toString() ?? '',
    );
  }

  void handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newLocker = Locker(
        number: int.parse(_numberController.text.trim()),
        floor: _floorController.text.trim(),
        responsible: _responsibleController.text.trim(),
        numberKeys: int.parse(_numberKeysController.text.trim()),
        lockNumber: int.parse(_lockNumberController.text.trim()),
        id: widget.locker?.id ?? uuid.v4(),
        place: '',
        lockerCondition: LockerCondition.good(),
        studentId: widget.locker?.studentId,
      );

      final notifier = ref.read(lockersRepositoryProvider.notifier);

      if (widget.locker == null) {
        // création
        notifier.addLocker(newLocker);
      } else {
        // modification
        notifier.editLocker(widget.locker!.number, newLocker);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _floorController.dispose();
    _responsibleController.dispose();
    _numberKeysController.dispose();
    _lockNumberController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire'.hardcoded;
    }
    return null;
  }

  String? _validateInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire'.hardcoded;
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Veuillez entrer un nombre valide'.hardcoded;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.locker != null;

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: StyledTitle(
              isEditing
                  ? 'Modification du casier'.hardcoded
                  : 'Création d’un casier'.hardcoded,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p20,
              vertical: Sizes.p32,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: StyledHeading(
                        isEditing
                            ? 'Modifier le casier'.hardcoded
                            : 'Créer un nouveau casier'.hardcoded,
                      ),
                    ),
                    gapH32,
                    LockerTextField(
                      controller: _numberController,
                      text: 'Numéro du casier',
                      icon: Icons.confirmation_number,
                      validator: _validateInt,
                      keyboardType: TextInputType.number,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _floorController,
                      text: 'Étage',
                      icon: Icons.stairs,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _responsibleController,
                      text: 'Responsable',
                      icon: Icons.person,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _numberKeysController,
                      text: 'Nombre de clés',
                      icon: Icons.vpn_key,
                      validator: _validateInt,
                      keyboardType: TextInputType.number,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _lockNumberController,
                      text: 'Numéro de la serrure',
                      icon: Icons.lock,
                      validator: _validateInt,
                      keyboardType: TextInputType.number,
                    ),
                    gapH32,
                    Center(
                      child: StyledButton(
                        onPressed: handleSubmit,
                        child: StyledHeading(
                          isEditing
                              ? 'Modifier le casier'.hardcoded
                              : 'Créer le casier'.hardcoded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
