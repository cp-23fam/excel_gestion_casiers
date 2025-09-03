import 'package:excel_gestion_casiers/src/features/providers/lockers_provder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockersDetailsScreen extends StatelessWidget {
  static String routeName = 'lockers_details';

  const LockersDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number = ModalRoute.of(context)?.settings.arguments as int;
    final locker = context.read<LockersProvder>().getLockerByNumber(number);

    return Scaffold(
      appBar: AppBar(),
      body: locker == null
          ? Center(child: Text('Locker not found'))
          : Column(
              children: [
                Text(
                  'Casier ${locker.number}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text('Étage ${locker.floor} - ${locker.place}'),
                Divider(),
                Text('Informations:'),
                Text('Responsable : ${locker.responsible}'),
                Text(
                  'État: ${locker.lockerCondition.isLockerinGoodCondition ? 'Bon' : 'Mauvais'}',
                ),
                Text('Commentaires: ${locker.lockerCondition.comments ?? ''}'),
                Text('Problèmes: ${locker.lockerCondition.problems ?? ''}'),
                Divider(),
                Text('Libre: ${locker.student == null ? 'Oui' : 'Non'}'),
                if (locker.student != null)
                  Column(
                    children: [
                      Text(
                        '${locker.student!.surname} ${locker.student!.name} - ${locker.student!.job}',
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
