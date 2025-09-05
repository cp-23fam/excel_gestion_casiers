// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

part 'locker_condition.g.dart';

@HiveType(typeId: 2)
class LockerCondition {
  const LockerCondition(
    this.isLockerinGoodCondition, {
    this.comments,
    this.problems,
  });

  @HiveField(0)
  final bool isLockerinGoodCondition;
  @HiveField(1)
  final String? comments;
  @HiveField(2)
  final String? problems;

  factory LockerCondition.good({String? comments}) {
    return LockerCondition(true, comments: comments);
  }

  LockerCondition copyWith({
    bool? isLockerinGoodCondition,
    String? comments,
    String? problems,
  }) {
    return LockerCondition(
      isLockerinGoodCondition ?? this.isLockerinGoodCondition,
      comments: comments ?? this.comments,
      problems: problems ?? this.problems,
    );
  }
}
