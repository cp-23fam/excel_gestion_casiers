import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/lockers_list/lockers_list_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/students_list/students_list_screen.dart';

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
              icon: Icon(Icons.lock_outline),
              selectedIcon: Icon(Icons.lock),
              label: Text('Lockers'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Students'),
            ),
          ],
          useIndicator: true,
          elevation: 5.0,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        _selectedIndex == 0
            ? const Expanded(child: LockersListScreen())
            : const Expanded(child: StudentsListScreen()),
      ],
    );
  }
}
