import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/user_profile_model.dart';
import '../models/xp_history_item_model.dart';
import '../models/prayer_model.dart';
import '../models/streak_model.dart';
import '../models/temptation_model.dart';

part 'xp_repository.g.dart';

@Riverpod()
class XPRepository extends _$XPRepository {
  late Box<UserProfile> _userProfileBox;
  late Box<XPHistoryItem> _xpHistoryBox;

  @override
  FutureOr<void> build() async {
    _userProfileBox = ref
        .read(objectboxProvider)
        .requireValue
        .store
        .box<UserProfile>();
    _xpHistoryBox = ref
        .read(objectboxProvider)
        .requireValue
        .store
        .box<XPHistoryItem>();
  }

  // Add XP to user profile and create history entry (transaction)
  Future<XPHistoryItem> addXP(int amount, String description) async {
    try {
      // Get current user profile
      final userProfile = _userProfileBox.get(1);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      // Create XP history entry
      final xpHistoryItem = XPHistoryItem(
        amount: amount,
        description: description,
      );

      // Update user profile with new XP total
      final updatedUserProfile = userProfile.copyWith(
        xp: userProfile.xp + amount,
        lastUpdated: DateTime.now(),
      );

      // Perform transaction - update both profile and create history entry
      await _userProfileBox.putAsync(updatedUserProfile);
      await _xpHistoryBox.putAsync(xpHistoryItem);

      return xpHistoryItem;
    } catch (e) {
      throw Exception('Failed to add XP: ${e.toString()}');
    }
  }

  // Get user's current XP total
  int getUserXP() {
    final userProfile = _userProfileBox.get(1);
    return userProfile?.xp ?? 0;
  }

  // Get all XP history entries
  List<XPHistoryItem> getXPHistory() {
    return _xpHistoryBox.getAll();
  }

  // Get XP history entries sorted by creation date (newest first)
  List<XPHistoryItem> getXPHistorySorted() {
    final query = _xpHistoryBox
        .query()
        .order(XPHistoryItem_.createdAt, flags: Order.descending)
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get XP history entries by date range
  List<XPHistoryItem> getXPHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final query = _xpHistoryBox
        .query(XPHistoryItem_.createdAt.betweenDate(startDate, endDate))
        .order(XPHistoryItem_.createdAt, flags: Order.descending)
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get today's XP entries
  List<XPHistoryItem> getTodayXPHistory() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return getXPHistoryByDateRange(startOfDay, endOfDay);
  }

  // Get XP count
  int getXPHistoryCount() {
    return _xpHistoryBox.count();
  }

  // Delete XP history entry and reverse the XP amount
  Future<bool> deleteXP(int historyId) async {
    try {
      // Get the XP history entry
      final xpHistory = _xpHistoryBox.get(historyId);
      if (xpHistory == null) {
        return false;
      }

      // Get current user profile
      final userProfile = _userProfileBox.get(1);
      if (userProfile == null) {
        return false;
      }

      // Reverse the XP amount
      userProfile.xp -= xpHistory.amount;
      await _userProfileBox.putAsync(userProfile);

      // Delete the XP history entry
      final result = _xpHistoryBox.remove(historyId);

      return result;
    } catch (e) {
      throw Exception('Failed to delete XP: ${e.toString()}');
    }
  }

  // Delete XP history entry (legacy method)
  Future<bool> deleteXPHistoryItem(int id) async {
    try {
      final result = await _xpHistoryBox.removeAsync(id);
      return result;
    } catch (e) {
      throw Exception('Failed to delete XP history item: ${e.toString()}');
    }
  }

  // Delete all XP history entries
  Future<int> deleteAllXPHistory() async {
    try {
      final count = await _xpHistoryBox.removeAllAsync();
      return count;
    } catch (e) {
      throw Exception('Failed to delete all XP history: ${e.toString()}');
    }
  }

  // Watch user XP total for real-time updates
  Stream<int> watchUserXP() {
    return _userProfileBox
        .query(UserProfile_.id.equals(1))
        .watch(triggerImmediately: true)
        .asyncMap((query) async {
          final profile = await query.findFirstAsync();
          return profile?.xp ?? 0;
        });
  }

  // Watch XP history for real-time updates
  Stream<List<XPHistoryItem>> watchXPHistory() {
    return _xpHistoryBox
        .query()
        .order(XPHistoryItem_.createdAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync());
  }

  // Watch today's XP history for real-time updates
  Stream<List<XPHistoryItem>> watchTodayXPHistory() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startTimestamp = startOfDay.millisecondsSinceEpoch;
    final endTimestamp = endOfDay.millisecondsSinceEpoch;

    return _xpHistoryBox
        .query(XPHistoryItem_.createdAt.between(startTimestamp, endTimestamp))
        .order(XPHistoryItem_.createdAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  // Get total XP earned today
  int getTodayXPTotal() {
    final todayEntries = getTodayXPHistory();
    return todayEntries.fold(0, (total, entry) => total + entry.amount);
  }

  // Get total XP earned in a specific date range
  int getXPTotalByDateRange(DateTime startDate, DateTime endDate) {
    final entries = getXPHistoryByDateRange(startDate, endDate);
    return entries.fold(0, (total, entry) => total + entry.amount);
  }

  // Delete XP for a specific prayer
  Future<void> deleteXPOfPrayer(Prayer prayer) async {
    // First decrement XP in UserProfile
    UserProfile userProfile = _userProfileBox.get(1)!;

    final updatedUserProfile = userProfile.copyWith(
      xp: userProfile.xp - prayer.xpHistory.target!.amount,
      lastUpdated: DateTime.now(),
    );
    await _userProfileBox.putAsync(updatedUserProfile);

    // Then remove the XPHistoryItem
    await _xpHistoryBox.removeAsync(prayer.xpHistory.targetId);
  }

  // Delete XP for a specific streak
  Future<void> deleteXPOfStreak(Streak streak) async {
    // First decrement XP in UserProfile
    UserProfile userProfile = _userProfileBox.get(1)!;

    final updatedUserProfile = userProfile.copyWith(
      xp: userProfile.xp - streak.xpHistory.target!.amount,
      lastUpdated: DateTime.now(),
    );
    await _userProfileBox.putAsync(updatedUserProfile);

    // Then remove the XPHistoryItem
    await _xpHistoryBox.removeAsync(streak.xpHistory.targetId);
  }

  // Delete XP for a specific temptation
  Future<void> deleteXPOfTemptation(Temptation temptation) async {
    // First decrement XP in UserProfile
    UserProfile userProfile = _userProfileBox.get(1)!;

    final updatedUserProfile = userProfile.copyWith(
      xp: userProfile.xp - temptation.xpHistory.target!.amount,
      lastUpdated: DateTime.now(),
    );
    await _userProfileBox.putAsync(updatedUserProfile);

    // Then remove the XPHistoryItem
    await _xpHistoryBox.removeAsync(temptation.xpHistory.targetId);
  }
}
