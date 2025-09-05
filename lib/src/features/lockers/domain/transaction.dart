import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';

enum TransactionType { add, remove, edit }

class Transaction {
  const Transaction(this.type, this.lockerNumber, this.previousValue);

  final TransactionType type;
  final int lockerNumber;
  final Locker previousValue;

  Transaction copyWith({
    TransactionType? type,
    int? lockerNumber,
    Locker? previousValue,
  }) {
    return Transaction(
      type ?? this.type,
      lockerNumber ?? this.lockerNumber,
      previousValue ?? this.previousValue,
    );
  }
}
