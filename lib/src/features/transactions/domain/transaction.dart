import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
enum TransactionType {
  @HiveField(0)
  add,
  @HiveField(1)
  remove,
  @HiveField(2)
  edit,
}

@HiveType(typeId: 3)
class Transaction {
  Transaction({
    required this.id,
    required this.type,
    required this.isStudentBox,
    required this.boxItemId,
    required this.previousValue,
  }) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @HiveField(0)
  final String id;
  @HiveField(1)
  final TransactionType type;
  @HiveField(2)
  final bool isStudentBox;
  @HiveField(3)
  final String boxItemId;
  @HiveField(4)
  final dynamic previousValue;
  @HiveField(5)
  final int timestamp;

  Transaction copyWith({
    String? id,
    TransactionType? type,
    bool? isStudentBox,
    String? boxItemId,
    dynamic previousValue,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      isStudentBox: isStudentBox ?? this.isStudentBox,
      boxItemId: boxItemId ?? this.boxItemId,
      previousValue: previousValue ?? this.previousValue,
    );
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.isStudentBox == isStudentBox &&
        other.boxItemId == boxItemId &&
        other.previousValue == previousValue &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        isStudentBox.hashCode ^
        boxItemId.hashCode ^
        previousValue.hashCode ^
        timestamp.hashCode;
  }
}
