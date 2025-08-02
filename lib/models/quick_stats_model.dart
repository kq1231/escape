class QuickStats {
  final int totalPrayers;
  final int bestStreak;
  final int currentMood;
  final int progressToGoal;

  QuickStats({
    required this.totalPrayers,
    required this.bestStreak,
    required this.currentMood,
    required this.progressToGoal,
  });

  QuickStats copyWith({
    int? totalPrayers,
    int? bestStreak,
    int? currentMood,
    int? progressToGoal,
  }) {
    return QuickStats(
      totalPrayers: totalPrayers ?? this.totalPrayers,
      bestStreak: bestStreak ?? this.bestStreak,
      currentMood: currentMood ?? this.currentMood,
      progressToGoal: progressToGoal ?? this.progressToGoal,
    );
  }

  @override
  String toString() {
    return 'QuickStats(totalPrayers: $totalPrayers, bestStreak: $bestStreak, currentMood: $currentMood, progressToGoal: $progressToGoal)';
  }
}
