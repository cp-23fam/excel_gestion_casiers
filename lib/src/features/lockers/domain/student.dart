import 'package:hive_flutter/hive_flutter.dart';

part 'student.g.dart';

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
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? genderTitle;
  @HiveField(3)
  final String surname;
  @HiveField(4)
  final String? login;
  @HiveField(5)
  final String? formationYear;
  @HiveField(6)
  final String job;

  Student copyWith({
    String? id,
    String? name,
    String? genderTitle,
    String? surname,
    String? login,
    String? formationYear,
    String? job,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      genderTitle: genderTitle ?? this.genderTitle,
      surname: surname ?? this.surname,
      login: login ?? this.login,
      formationYear: formationYear ?? this.formationYear,
      job: job ?? this.job,
    );
  }
}
