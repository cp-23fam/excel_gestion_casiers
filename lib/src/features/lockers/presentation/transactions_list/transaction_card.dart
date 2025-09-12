import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    late dynamic transactionItem;
    if (transaction.isStudentBox) {
      transactionItem = transaction.previousValue;
    } else {
      transactionItem = transaction.previousValue;
    }
    return GestureDetector(
      onTap: () => LockersRepository().goBack(transaction.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p8,
          ),
          child: transaction.isStudentBox
              ? Row(
                  children: [
                    const Icon(Icons.swap_vertical_circle, size: Sizes.p24),
                    gapW8,
                    Expanded(child: StyledBoldText('${transaction.type}')),
                    gapW8,

                    Expanded(child: StyledBoldText(transactionItem?.name)),
                    Expanded(child: StyledBoldText(transactionItem?.surname)),
                  ],
                )
              : Row(
                  children: [
                    const Icon(Icons.swap_vertical_circle, size: Sizes.p24),
                    gapW8,
                    Expanded(child: StyledBoldText('${transaction.type}')),
                    gapW8,

                    Expanded(
                      child: StyledBoldText('N° ${transactionItem?.number}'),
                    ),
                    Expanded(child: StyledBoldText(transactionItem?.floor)),
                  ],
                ),
        ),
      ),
    );
  }
}
