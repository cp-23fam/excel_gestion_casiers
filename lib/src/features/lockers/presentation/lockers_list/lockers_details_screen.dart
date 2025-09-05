import 'package:excel_gestion_casiers/src/features/providers/lockers_provder.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockersDetailsScreen extends StatefulWidget {
  static String routeName = 'lockers_details';

  const LockersDetailsScreen({super.key});

  @override
  State<LockersDetailsScreen> createState() => _LockersDetailsScreenState();
}

class _LockersDetailsScreenState extends State<LockersDetailsScreen> {
  late final Locker? locker;
  @override
  void initState() async {
    final number = ModalRoute.of(context)?.settings.arguments as int;
    locker = await context.read<LockersProvder>().getLockerByNumber(number);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: locker == null
          ? const Center(child: Text('Locker not found'))
          : Column(
              children: [
                Text(
                  'Casier ${locker!.number}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text('Étage ${locker!.floor} - ${locker!.place}'),
                const Divider(),
                const Text('Informations:'),
                Text('Responsable : ${locker!.responsible}'),
                Text(
                  'État: ${locker!.lockerCondition.isLockerinGoodCondition ? 'Bon' : 'Mauvais'}',
                ),
                Text('Commentaires: ${locker!.lockerCondition.comments ?? ''}'),
                Text('Problèmes: ${locker!.lockerCondition.problems ?? ''}'),
                const Divider(),
                Text('Libre: ${locker!.student == null ? 'Oui' : 'Non'}'),
                if (locker!.student != null)
                  Column(
                    children: [
                      Text(
                        '${locker!.student!.surname} ${locker!.student!.name} - ${locker!.student!.job}',
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
