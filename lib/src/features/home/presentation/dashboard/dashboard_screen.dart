import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/students/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/home/presentation/dashboard/dashboard_card.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:excel_gestion_casiers/src/utils/lockers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Dashboard'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Consumer(
          builder: (context, ref, child) {
            final lockers = ref
                .read(lockersRepositoryProvider.notifier)
                .getLockersList();

            final lockersErrorCount = lockers
                .where(
                  (locker) => locker.lockerCondition.isConditionGood == false,
                )
                .length;

            final keysWarningCount = filterLockers(
              lockers,
              numberKeys: 1,
            ).length;

            final studentsCount = ref
                .read(studentRepositoryProvider.notifier)
                .getStudentList()
                .length;

            final studentsErrorCount = ref
                .read(studentRepositoryProvider.notifier)
                .getFreeStudents()
                .length;

            return lockers.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: StyledTitle('Bienvenue'.hardcoded)),
                      gapH12,
                      Center(
                        child: StyledText(
                          'Aucune donée disponible...'.hardcoded,
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    children: [
                      DashboardCard(
                        text: 'Général'.hardcoded,
                        condition:
                            (lockersErrorCount != 0 || studentsErrorCount > 0)
                            ? 2
                            : (keysWarningCount > 0)
                            ? 1
                            : 0,
                        comment:
                            (lockersErrorCount +
                                    studentsErrorCount +
                                    keysWarningCount) ==
                                1
                            ? '1 problème majeur ou mineur'.hardcoded
                            : '${lockersErrorCount + studentsErrorCount + keysWarningCount} problèmes majeurs ou mineurs'
                                  .hardcoded,
                        logo: Icons.inbox,
                        value:
                            (2 * lockers.length +
                                studentsCount -
                                (lockersErrorCount +
                                    studentsErrorCount +
                                    keysWarningCount)) /
                            (2 * lockers.length + studentsCount),
                      ),
                      DashboardCard(
                        text: 'Casiers',
                        condition: lockersErrorCount == 0 ? 0 : 2,
                        comment: lockersErrorCount == 0
                            ? 'Tous les casiers sont en ordre'.hardcoded
                            : lockersErrorCount == 1
                            ? '1 casier à des problèmes'.hardcoded
                            : '$lockersErrorCount casiers ont des problèmes'
                                  .hardcoded,
                        logo: Icons.lock,
                        value: 1 - lockersErrorCount / lockers.length,
                      ),
                      DashboardCard(
                        text: 'Élèves',
                        condition: studentsErrorCount > 0 ? 2 : 0,
                        comment: studentsErrorCount < 1
                            ? 'Tous les élèves sont en ordre'.hardcoded
                            : studentsErrorCount == 1
                            ? '1 élève n\'a pas de casier'.hardcoded
                            : '$studentsErrorCount élèves n\'ont pas de casier'
                                  .hardcoded,
                        logo: Icons.person,
                        value: 1 - studentsErrorCount / studentsCount,
                      ),
                      DashboardCard(
                        text: 'Clés',
                        condition: keysWarningCount > 0 ? 1 : 0,
                        comment: keysWarningCount < 1
                            ? 'Tous les casiers possèdent des rechanges'
                                  .hardcoded
                            : keysWarningCount == 1
                            ? '1 casier n\'a pas de rechanges'.hardcoded
                            : '$keysWarningCount casiers n\'ont pas de rechange'
                                  .hardcoded,
                        logo: Icons.key,
                        value: 1 - keysWarningCount / lockers.length,
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
