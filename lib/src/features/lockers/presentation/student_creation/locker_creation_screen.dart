import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_creation/locker_text_field.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class StudentCreationScreen extends ConsumerStatefulWidget {
  final Student? student;

  const StudentCreationScreen({super.key, this.student});

  @override
  ConsumerState<StudentCreationScreen> createState() =>
      _StudentCreationScreenState();
}

class _StudentCreationScreenState extends ConsumerState<StudentCreationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _genderTitleController;
  late final TextEditingController _surnameController;
  late final TextEditingController _loginController;
  late final TextEditingController _cautionController;
  late final TextEditingController _formationYearController;
  late final TextEditingController _jobController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialiser les controllers, avec les valeurs existantes si on modifie
    _nameController = TextEditingController(
      text: widget.student?.name.toString() ?? '',
    );
    _genderTitleController = TextEditingController(
      text: widget.student?.genderTitle.toString() ?? '',
    );
    _surnameController = TextEditingController(
      text: widget.student?.surname.toString() ?? '',
    );
    _loginController = TextEditingController(
      text: widget.student?.login.toString() ?? '',
    );
    _cautionController = TextEditingController(
      text: widget.student?.caution.toString() ?? '20',
    );
    _formationYearController = TextEditingController(
      text: widget.student?.formationYear.toString() ?? '',
    );
    _jobController = TextEditingController(
      text: widget.student?.job.toString() ?? '',
    );
  }

  void handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newStudent = Student(
        id: widget.student?.id ?? uuid.v4(),
        name: _nameController.text.trim(),
        genderTitle: _genderTitleController.text.trim(),
        surname: _surnameController.text.trim(),
        login: _loginController.text.trim(),
        caution: int.parse(_cautionController.text.trim()),
        formationYear: int.parse(_formationYearController.text.trim()),
        job: _jobController.text.trim(),
      );

      final notifier = ref.read(lockersListNotifierProvider.notifier);

      if (widget.student == null) {
        // création
        notifier.addStudent(newStudent);
      } else {
        // modification
        notifier.editStudent(newStudent);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderTitleController.dispose();
    _surnameController.dispose();
    _loginController.dispose();
    _cautionController.dispose();
    _formationYearController.dispose();
    _jobController.dispose();
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
    final isEditing = widget.student != null;

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: StyledTitle(
              isEditing
                  ? 'Modification de l\'élève'.hardcoded
                  : 'Création d’un élève'.hardcoded,
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
                            ? 'Modifier l\'élève'.hardcoded
                            : 'Créer un nouvel élève'.hardcoded,
                      ),
                    ),
                    gapH32,
                    LockerTextField(
                      controller: _nameController,
                      text: 'Prénom de l\'élève',
                      icon: Icons.person_outline,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _surnameController,
                      text: 'Nom de l\'élève',
                      icon: Icons.badge,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _genderTitleController,
                      text: 'Titre de l\'élève',
                      icon: Icons.wc,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _loginController,
                      text: 'Login de l\'élève',
                      icon: Icons.alternate_email,
                      validator: _validateRequired,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _cautionController,
                      text: 'Caution de l\'élève',
                      icon: Icons.money,
                      validator: _validateInt,
                      keyboardType: TextInputType.number,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _formationYearController,
                      text: 'Année de formation de l\'élève',
                      icon: Icons.calendar_today,
                      validator: _validateInt,
                      keyboardType: TextInputType.number,
                    ),
                    gapH20,
                    LockerTextField(
                      controller: _jobController,
                      text: 'Métier de l\'élève',
                      icon: Icons.work_outline,
                      validator: _validateRequired,
                    ),
                    gapH32,
                    Center(
                      child: StyledButton(
                        onPressed: handleSubmit,
                        child: StyledHeading(
                          isEditing
                              ? 'Modifier l\'élève'.hardcoded
                              : 'Créer l\'élève'.hardcoded,
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
