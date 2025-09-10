import 'package:hive_flutter/hive_flutter.dart';

part 'student.g.dart';

typedef StudentID = String;

@HiveType(typeId: 1)
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.genderTitle,
    required this.surname,
    required this.login,
    required this.formationYear,
    required this.job,
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
  final int formationYear;
  @HiveField(6)
  final String login;

  Student copyWith({
    StudentID? id,
    String? genderTitle,
    String? name,
    String? surname,
    String? job,
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
    );
  }
}
