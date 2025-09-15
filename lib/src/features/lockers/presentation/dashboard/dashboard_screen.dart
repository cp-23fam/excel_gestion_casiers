import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/dashboard/dashboard_card.dart';
import 'package:excel_gestion_casiers/utils/lockers.dart';
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Consumer(
          builder: (context, ref, child) {
            final lockers = ref
                .read(lockersRepositoryProvider.notifier)
                .fetchLockersList();

            final lockersErrorCount = filterLockers(
              lockers,
              hasProblems: true,
            ).length;
            final keysWarningCount = filterLockers(
              lockers,
              numberKeys: 1,
            ).length;

            final studentsCount = ref
                .read(studentRepositoryProvider.notifier)
                .fetchStudents()
                .length;

            final studentsErrorCount = ref
                .read(studentRepositoryProvider.notifier)
                .fetchNoLockerStudents()
                .length;

            return Wrap(
              children: [
                DashboardCard(
                  text: 'Casiers',
                  condition: lockersErrorCount < 1 ? 0 : 2,
                  comment: lockersErrorCount < 1
                      ? 'Tous les casiers sont en ordre'
                      : lockersErrorCount == 1
                      ? '1 casier à des problèmes'
                      : '$lockersErrorCount casiers ont des problèmes',
                  logo: Icons.lock,
                  value:
                      1 -
                      lockersErrorCount /
                          (lockers.isEmpty ? 1 : lockers.length),
                ),
                DashboardCard(
                  text: 'Élèves',
                  condition: studentsErrorCount > 0 ? 2 : 0,
                  comment: studentsErrorCount < 1
                      ? 'Tous les élèves sont en ordre'
                      : studentsErrorCount == 1
                      ? '1 élève n\'a pas de casier'
                      : '$studentsErrorCount élèves n\'ont pas de casier',
                  logo: Icons.person,
                  value:
                      1 -
                      studentsErrorCount /
                          (studentsCount == 0 ? 1 : studentsCount),
                ),
                DashboardCard(
                  text: 'Clés',
                  condition: keysWarningCount > 0 ? 1 : 0,
                  comment: keysWarningCount < 1
                      ? 'Tous les casiers possèdent des rechanges'
                      : keysWarningCount == 1
                      ? '1 casier n\'a pas de rechange'
                      : '$keysWarningCount casiers n\'ont pas de rechange',
                  logo: Icons.key,
                  value:
                      1 -
                      keysWarningCount / (lockers.isEmpty ? 1 : lockers.length),
                ),
                DashboardCard(
                  text: 'Général',
                  condition: (lockersErrorCount > 1 || studentsErrorCount > 0)
                      ? 2
                      : (keysWarningCount > 0)
                      ? 1
                      : 0,
                  comment:
                      (lockersErrorCount +
                              studentsErrorCount +
                              keysWarningCount) ==
                          1
                      ? '1 problème majeur ou mineur'
                      : '${lockersErrorCount + studentsErrorCount + keysWarningCount} problèmes majeurs ou mineurs',
                  logo: Icons.inbox,
                  value: 0.96,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
