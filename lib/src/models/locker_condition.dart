// ignore_for_file: public_member_api_docs, sort_constructors_first
class LockerCondition {
  const LockerCondition(
    this.isLockerinGoodCondition, {
    this.comments,
    this.problems,
  });

  final bool isLockerinGoodCondition;
  final String? comments;
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
