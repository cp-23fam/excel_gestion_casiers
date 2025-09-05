// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.job,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String surname;
  @HiveField(3)
  final String job;

  Student copyWith({String? id, String? name, String? surname, String? job}) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      job: job ?? this.job,
    );
  }
}
