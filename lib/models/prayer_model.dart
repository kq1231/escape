import 'package:objectbox/objectbox.dart';

@Entity()
class Prayer {
  @Id()
  int id = 0;

  // Prayer name (Fajr, Dhuhr, Asr, Maghrib, Isha)
  String name;

  // Status of the prayer (completed or not)
  bool isCompleted;

  // Date of the prayer record
  @Property(type: PropertyType.date)
  DateTime date;

  // Constructor
  Prayer({
    this.id = 0,
    required this.name,
    this.isCompleted = false,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Copy with method for immutability
  Prayer copyWith({int? id, String? name, bool? isCompleted, DateTime? date}) {
    return Prayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Prayer(id: $id, name: $name, isCompleted: $isCompleted, date: $date)';
  }
}
