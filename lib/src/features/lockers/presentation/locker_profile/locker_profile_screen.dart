import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/students/domain/student.dart';
import 'package:excel_gestion_casiers/src/theme/theme.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';

class LockerProfileScreen extends ConsumerWidget {
  final String lockerId;
  final Function(Locker locker) editLocker;
  final Function(Locker locker) linkStudent;
  final Function(Locker locker) editLockerCondition;

  const LockerProfileScreen({
    super.key,
    required this.lockerId,
    required this.editLocker,
    required this.linkStudent,
    required this.editLockerCondition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockersRepository = ref.watch(lockersRepositoryProvider.notifier);
    final studentsRepository = ref.watch(studentRepositoryProvider.notifier);

    final lockers = lockersRepository.fetchLockersList();
    final locker = lockers.firstWhere((l) => l.id == lockerId);
    final Student? student = studentsRepository.getStudentBy(
      locker.studentId ?? '',
    );

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            title: StyledTitle('Details'.hardcoded),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p16,
                      vertical: Sizes.p16,
                    ),
                    child: Column(
                      children: [
                        _buildLockerInfoRow(
                          'Numéro du casier'.hardcoded,
                          locker.number.toString(),
                        ),
                        _buildLockerInfoRow('Étage'.hardcoded, locker.floor),
                        _buildLockerInfoRow(
                          'Responsable'.hardcoded,
                          locker.responsible,
                        ),
                        _buildLockerInfoRow(
                          'Caution'.hardcoded,
                          student != null ? '${student.caution}.-' : '-',
                        ),
                        _buildLockerInfoRow(
                          'Nombre de clés'.hardcoded,
                          locker.numberKeys.toString(),
                        ),
                        _buildLockerInfoRow(
                          'N° de cadenas'.hardcoded,
                          locker.lockNumber.toString(),
                        ),
                      ],
                    ),
                  ),
                ),

                student == null
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p16,
                            vertical: Sizes.p8,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: Sizes.p64),
                              gapW12,
                              StyledBoldText('-'.hardcoded),
                              const Expanded(child: SizedBox()),
                              Center(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        linkStudent(locker);
                                      },
                                      icon: const Icon(Icons.link),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p16,
                            vertical: Sizes.p8,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: Sizes.p64),
                              gapW12,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StyledBoldText(student.surname),
                                  StyledBoldText(student.name),
                                  StyledText(student.job),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Center(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        linkStudent(locker);
                                      },
                                      icon: const Icon(Icons.link),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        lockersRepository.freeLockerByIndex(
                                          locker.number,
                                        );
                                      },
                                      icon: const Icon(Icons.link_off),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Card(
                  child: Column(
                    children: [
                      !locker.lockerCondition.isConditionGood
                          ? Container(
                              width: double.infinity,
                              color: AppColors.deleteColor.withAlpha(50),
                              child: Icon(
                                Icons.error,
                                color: AppColors.deleteColor,
                              ),
                            )
                          : locker.lockerCondition.problems == null
                          ? Container(
                              width: double.infinity,
                              color: AppColors.goodColor.withAlpha(50),
                              child: Icon(
                                Icons.check,
                                color: AppColors.goodColor,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: AppColors.warningColor.withAlpha(50),
                              child: Icon(
                                Icons.warning,
                                color: AppColors.warningColor,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.p16,
                          vertical: Sizes.p16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLockerInfoRow(
                              'Problèmes'.hardcoded,
                              locker.lockerCondition.problems ?? '-',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StyledHeading('Commentaires'.hardcoded),
                                  gapH4,
                                  SizedBox(
                                    width: double.infinity,
                                    child: StyledText(
                                      locker.lockerCondition.comments ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  editLockerCondition(locker);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.iconColor,
                                ),
                                label: const StyledTitle('Modifier'),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.editColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          editLocker(locker);
                        },
                        icon: Icon(Icons.edit, color: AppColors.iconColor),
                        label: const StyledTitle('Modifier'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.editColor,
                          ),
                        ),
                      ),
                    ),
                    gapW20,
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          lockersRepository.deleteLocker(locker.number);
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.delete, color: AppColors.iconColor),
                        label: const StyledTitle('Supprimer'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.deleteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockerInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: StyledHeading(label)),
          gapW8,
          SizedBox(child: StyledText(value)),
        ],
      ),
    );
  }
}
