import 'package:hive_flutter/hive_flutter.dart';

part 'student.g.dart';

typedef StudentID = String;

@HiveType(typeId: 1)
class Student {
  const Student({
    required this.id,
    required this.genderTitle,
    required this.name,
    required this.surname,
    required this.job,
    required this.caution,
    required this.formationYear,
    required this.login,
  });

  @HiveField(0)
  final StudentID id;
  @HiveField(1)
  final String genderTitle;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String surname;
  @HiveField(4)
  final String job;
  @HiveField(5)
  final int caution;
  @HiveField(6)
  final int formationYear;
  @HiveField(7)
  final String login;

  Student copyWith({
    StudentID? id,
    String? genderTitle,
    String? name,
    String? surname,
    String? job,
    int? caution,
    int? formationYear,
    String? login,
  }) {
    return Student(
      id: id ?? this.id,
      genderTitle: genderTitle ?? this.genderTitle,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      job: job ?? this.job,
      formationYear: formationYear ?? this.formationYear,
      login: login ?? this.login,
      caution: caution ?? this.caution,
    );
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.genderTitle == genderTitle &&
        other.name == name &&
        other.surname == surname &&
        other.job == job &&
        other.caution == caution &&
        other.formationYear == formationYear &&
        other.login == login;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        genderTitle.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        job.hashCode ^
        caution.hashCode ^
        formationYear.hashCode ^
        login.hashCode;
  }
}
