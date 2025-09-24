import 'package:hive_flutter/hive_flutter.dart';

part 'locker_condition.g.dart';

@HiveType(typeId: 2)
class LockerCondition {
  const LockerCondition({
    this.isConditionGood = true,
    this.comments,
    this.problems,
  });

  @HiveField(0)
  final bool isConditionGood;
  @HiveField(1)
  final String? comments;
  @HiveField(2)
  final String? problems;

  factory LockerCondition.good({String? comments}) {
    return LockerCondition(isConditionGood: true, comments: comments);
  }

  LockerCondition copyWith({
    bool? isConditionGood,
    String? comments,
    String? problems,
  }) {
    return LockerCondition(
      isConditionGood: isConditionGood ?? this.isConditionGood,
      comments: comments ?? this.comments,
      problems: problems ?? this.problems,
    );
  }

  @override
  bool operator ==(covariant LockerCondition other) {
    if (identical(this, other)) return true;

    return other.isConditionGood == isConditionGood &&
        other.comments == comments &&
        other.problems == problems;
  }

  @override
  int get hashCode =>
      isConditionGood.hashCode ^ comments.hashCode ^ problems.hashCode;
}
