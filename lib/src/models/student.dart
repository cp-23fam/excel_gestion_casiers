// ignore_for_file: public_member_api_docs, sort_constructors_first
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.job,
  });

  final String id;
  final String name;
  final String surname;
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
