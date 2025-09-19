import 'package:excel_gestion_casiers/src/features/home/presentation/dashboard/dashboard_screen.dart';
import 'package:excel_gestion_casiers/src/features/locker_student_link/presentation/links_list/links_list_screen.dart';
import 'package:excel_gestion_casiers/src/features/transactions/presentation/transactions_list/transactions_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/lockers_list/lockers_list_screen.dart';
import 'package:excel_gestion_casiers/src/features/students/presentation/students_list/students_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: <NavigationRailDestination>[
            const NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Dashboard'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.lock_outline),
              selectedIcon: Icon(Icons.lock),
              label: Text('Lockers'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Students'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.link),
              selectedIcon: Icon(Icons.link_outlined),
              label: Text('Students'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.swap_vertical_circle_outlined),
              selectedIcon: Icon(Icons.swap_vertical_circle),
              label: Text('Transactions'),
            ),
          ],
          useIndicator: true,
          elevation: 5.0,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        _selectedIndex == 0
            ? const Expanded(child: DashboardScreen())
            : _selectedIndex == 1
            ? const Expanded(child: LockersListScreen())
            : _selectedIndex == 2
            ? const Expanded(child: StudentsListScreen())
            : _selectedIndex == 3
            ? const Expanded(child: LinksListScreen())
            : const Expanded(child: TransactionsListScreen()),
      ],
    );
  }
}
