import 'package:excel_gestion_casiers/src/common_widgets/styled_button.dart';
import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/transaction_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:excel_gestion_casiers/src/features/lockers/presentation/transactions_list/transaction_card.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:excel_gestion_casiers/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = TransactionRepository()
        .fetchTransactionList();

    transactions.sort((a, b) => b.timestamp - a.timestamp);
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Transactions'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StyledButton(
                  onPressed: () => setState(() {
                    TransactionRepository().goBack(transactions.last.id);
                  }),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.iconColor,
                        size: 30.0,
                      ),
                      gapW12,
                      StyledTitle('Previous'.hardcoded),
                    ],
                  ),
                ),
              ],
            ),
            gapH24,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return transactions.isEmpty
                      ? Center(
                          child: StyledText(
                            'Aucune transaction effectuée.'.hardcoded,
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (_, index) {
                            final transaction = transactions[index];
                            return TransactionCard(transaction: transaction);
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
}
