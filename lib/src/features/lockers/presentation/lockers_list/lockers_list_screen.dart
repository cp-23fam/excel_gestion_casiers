import 'package:excel/excel.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/locker_profile/locker_profile_screen.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/lockers_list/locker_card.dart';
import 'package:excel_gestion_casiers/utils/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class LockersListScreen extends ConsumerStatefulWidget {
  const LockersListScreen({super.key});

  @override
  ConsumerState<LockersListScreen> createState() => _LockersListScreenState();
}

class _LockersListScreenState extends ConsumerState<LockersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const StyledTitle('Lockers')),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledButton(
              onPressed: () async {
                FilePickerResult? pickedFile = await FilePicker.platform
                    .pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx'],
                      allowMultiple: false,
                    );

                if (pickedFile != null) {
                  var bytes = pickedFile.files.single.bytes!.toList();
                  var excel = Excel.decodeBytes(bytes);
                  importFile(excel);
                }
              },
              child: const Icon(Icons.add, color: Colors.white, size: 30.0),
            ),

            gapH24,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final lockersRepository = ref.watch(
                    lockersRepositoryProvider,
                  );
                  final lockers = lockersRepository.fetchLockersList();
                  return ListView.builder(
                    itemCount: lockers.length,
                    itemBuilder: (_, index) {
                      final locker = lockers[index];
                      return LockerCard(
                        locker: locker,
                        infoLocker: (locker) => _infoLocker(locker: locker),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _infoLocker({Locker? locker}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Locker Info',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LockerProfileScreen(locker: locker);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        );
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }
}
