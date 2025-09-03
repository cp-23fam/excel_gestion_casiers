import 'package:excel_gestion_casiers/src/features/lockers_list/lockers_details_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers_list/lockers_list_screen.dart';
import 'package:excel_gestion_casiers/src/features/providers/lockers_provder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LockersProvder>(
          create: (context) => LockersProvder(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => LockersListScreen(),
          LockersDetailsScreen.routeName: (context) => LockersDetailsScreen(),
        },
        // home: LockersListScreen(),
      ),
    );
  }
}
