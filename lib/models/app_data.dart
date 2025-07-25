class AppData {
  int streak;
  DateTime? lastPrayerTime;
  bool isPrayerCompleted;
  List<RelapseEntry> relapseHistory;
  DateTime startDate;
  int totalDays;
  int challengesCompleted;
  Map<String, dynamic> preferences;

  AppData({
    this.streak = 0,
    this.lastPrayerTime,
    this.isPrayerCompleted = false,
    List<RelapseEntry>? relapseHistory,
    DateTime? startDate,
    this.totalDays = 0,
    this.challengesCompleted = 0,
    Map<String, dynamic>? preferences,
  }) : relapseHistory = relapseHistory ?? [],
       startDate = startDate ?? DateTime.now(),
       preferences = preferences ?? {};

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'streak': streak,
      'lastPrayerTime': lastPrayerTime?.millisecondsSinceEpoch,
      'isPrayerCompleted': isPrayerCompleted,
      'relapseHistory': relapseHistory.map((e) => e.toJson()).toList(),
      'startDate': startDate.millisecondsSinceEpoch,
      'totalDays': totalDays,
      'challengesCompleted': challengesCompleted,
      'preferences': preferences,
    };
  }

  // Create from JSON
  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      streak: json['streak'] as int? ?? 0,
      lastPrayerTime: json['lastPrayerTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPrayerTime'] as int)
          : null,
      isPrayerCompleted: json['isPrayerCompleted'] as bool? ?? false,
      relapseHistory:
          (json['relapseHistory'] as List<dynamic>?)
              ?.map((e) => RelapseEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      startDate: json['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int)
          : DateTime.now(),
      totalDays: json['totalDays'] as int? ?? 0,
      challengesCompleted: json['challengesCompleted'] as int? ?? 0,
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  // Copy with method for immutability
  AppData copyWith({
    int? streak,
    DateTime? lastPrayerTime,
    bool? isPrayerCompleted,
    List<RelapseEntry>? relapseHistory,
    DateTime? startDate,
    int? totalDays,
    int? challengesCompleted,
    Map<String, dynamic>? preferences,
  }) {
    return AppData(
      streak: streak ?? this.streak,
      lastPrayerTime: lastPrayerTime ?? this.lastPrayerTime,
      isPrayerCompleted: isPrayerCompleted ?? this.isPrayerCompleted,
      relapseHistory: relapseHistory ?? this.relapseHistory,
      startDate: startDate ?? this.startDate,
      totalDays: totalDays ?? this.totalDays,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      preferences: preferences ?? this.preferences,
    );
  }
}

class RelapseEntry {
  DateTime date;
  String reason;
  String notes;

  RelapseEntry({required this.date, required this.reason, this.notes = ''});

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'reason': reason,
      'notes': notes,
    };
  }

  factory RelapseEntry.fromJson(Map<String, dynamic> json) {
    return RelapseEntry(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      reason: json['reason'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }
}
