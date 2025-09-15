import 'package:excel_gestion_casiers/src/features/lockers/data/lockers_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/data/students_repository.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/locker.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/student.dart';
import 'package:excel_gestion_casiers/src/features/lockers/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TransactionRepository extends Notifier<List<Transaction>> {
  static final Box<Transaction> transactionsBox = Hive.box('transactions');

  // Transaction
  void saveTransaction(
    TransactionType type,
    bool isStudentBox, {
    Locker? lockerValue,
    Student? studentValue,
  }) {
    if (isStudentBox && studentValue == null) {
      return;
    }

    if (!isStudentBox && lockerValue == null) {
      return;
    }

    final String id = uuid.v4();
    if (isStudentBox) {
      transactionsBox.put(
        id,
        Transaction(
          id: id,
          type: type,
          boxItemId: studentValue!.id,
          previousValue: studentValue,
          isStudentBox: true,
        ),
      );
    } else {
      transactionsBox.put(
        id,
        Transaction(
          id: id,
          type: type,
          boxItemId: lockerValue!.number.toString(),
          isStudentBox: false,
          previousValue: lockerValue,
        ),
      );
    }
  }

  void goBack(String id) {
    if (transactionsBox.keys.isEmpty) {
      return;
    }

    final transaction = transactionsBox.get(id);

    if (transaction == null) {
      return;
    }

    if (transaction.isStudentBox) {
      Student student = transaction.previousValue as Student;

      switch (transaction.type) {
        case TransactionType.add:
          StudentsRepository.studentsBox.delete(transaction.boxItemId);
          break;
        case TransactionType.remove:
          StudentsRepository.studentsBox.put(transaction.boxItemId, student);
          break;
        case TransactionType.edit:
          StudentsRepository.studentsBox.put(transaction.boxItemId, student);
          break;
      }
    } else {
      int lockerNumber = int.parse(transaction.boxItemId);

      Locker locker = transaction.previousValue as Locker;

      switch (transaction.type) {
        case TransactionType.add:
          LockersRepository.lockersBox.delete(lockerNumber);
          break;
        case TransactionType.remove:
          LockersRepository.lockersBox.put(lockerNumber, locker);
          break;
        case TransactionType.edit:
          LockersRepository.lockersBox.put(lockerNumber, locker);
          break;
      }
    }

    transactionsBox.delete(id);
  }

  List<Transaction> fetchTransactionList() {
    final transactions = <Transaction>[];

    for (int i = 0; i < transactionsBox.length; i++) {
      final Transaction? transaction = transactionsBox.getAt(i);

      if (transaction != null) {
        transactions.add(transaction);
      }
    }

    return transactions;
  }

  void clearTransactions() {
    for (int i = 0; i < transactionsBox.length; i++) {
      transactionsBox.deleteAt(i);
    }
  }

  @override
  build() {
    return [];
  }
}

final transactionRepositoryProvider =
    NotifierProvider<TransactionRepository, List<Transaction>>(() {
      return TransactionRepository();
    });
