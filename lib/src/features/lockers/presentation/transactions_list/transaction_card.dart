import 'package:excel_gestion_casiers/src/common_widgets/styled_text.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/transaction_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:excel_gestion_casiers/src/features/theme/theme.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });
  final Transaction transaction;
  final Function(String id) onTap;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    late dynamic transactionItem;
    if (widget.transaction.isStudentBox) {
      transactionItem = widget.transaction.previousValue;
    } else {
      transactionItem = widget.transaction.previousValue;
    }
    return GestureDetector(
      onTap: () => widget.onTap(widget.transaction.id),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: Card(
          color: isHover ? AppColors.primaryAccent : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p8,
            ),
            child: widget.transaction.isStudentBox
                ? Row(
                    children: [
                      const Icon(Icons.swap_vertical_circle, size: Sizes.p24),
                      gapW8,
                      Expanded(
                        child: StyledBoldText('${widget.transaction.type}'),
                      ),
                      gapW8,

                      Expanded(child: StyledBoldText(transactionItem?.name)),
                      Expanded(child: StyledBoldText(transactionItem?.surname)),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.swap_vertical_circle, size: Sizes.p24),
                      gapW8,
                      Expanded(
                        child: StyledBoldText('${widget.transaction.type}'),
                      ),
                      gapW8,

                      Expanded(
                        child: StyledBoldText('N° ${transactionItem?.number}'),
                      ),
                      Expanded(child: StyledBoldText(transactionItem?.floor)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
