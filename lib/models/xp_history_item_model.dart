import 'package:objectbox/objectbox.dart';

@Entity()
class XPHistoryItem {
  @Id()
  int id = 0;

  // XP amount awarded
  int amount;

  // Description of why/when XP was awarded
  String description;

  // Creation timestamp
  @Property(type: PropertyType.date)
  DateTime createdAt;

  // Constructor
  XPHistoryItem({
    this.id = 0,
    required this.amount,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Copy with method for immutability
  XPHistoryItem copyWith({
    int? id,
    int? amount,
    String? description,
    DateTime? createdAt,
  }) {
    return XPHistoryItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'XPHistoryItem(id: $id, amount: $amount, description: $description, createdAt: $createdAt)';
  }
}
