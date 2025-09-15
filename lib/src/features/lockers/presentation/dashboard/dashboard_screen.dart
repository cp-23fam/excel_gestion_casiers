import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/dashboard/dashboard_card.dart';
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
      body: const Padding(
        padding: EdgeInsets.all(Sizes.p24),
        child: Wrap(
          children: [
            DashboardCard(
              text: 'Casiers',
              condition: 0,
              comment: 'Tous les casiers sont en ordre',
              logo: Icons.lock,
              value: 1,
            ),
            DashboardCard(
              text: 'Élèves',
              condition: 2,
              comment: '2 élèves n\'ont pas de casier',
              logo: Icons.person,
              value: 0.9,
            ),
            DashboardCard(
              text: 'Clés',
              condition: 1,
              comment: '2 casiers n\'ont pas de rechange',
              logo: Icons.lock,
              value: 0.92,
            ),
            DashboardCard(
              text: 'Général',
              condition: 2,
              comment: '2 problèmes mineurs et majeurs',
              logo: Icons.lock,
              value: 0.96,
            ),
          ],
        ),
      ),
    );
  }
}
