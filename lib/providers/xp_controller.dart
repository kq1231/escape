import 'package:escape/models/xp_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/xp_repository.dart';
import '../models/prayer_model.dart';
import '../models/streak_model.dart';
import '../models/temptation.dart';

part 'xp_controller.g.dart';

/// A controller that handles XP-related operations
@Riverpod(keepAlive: true)
class XPController extends _$XPController {
  @override
  Future<void> build() async {
    // No-op - the controller doesn't initialize anything
  }

  /// Create XP by adding points to user profile and creating history entry
  Future<XPHistoryItem> createXP(
    int amount,
    String description, {
    BuildContext? context,
  }) async {
    late XPHistoryItem xpHistoryItem;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      xpHistoryItem = await ref
          .read(xPRepositoryProvider.notifier)
          .addXP(amount, description);
    });

    // If successful then show snackbar if context is not null
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added $amount points to XP!")));
    }

    return xpHistoryItem;
  }

  /// Delete XP of Prayer - reverses XP when prayer is unmarked
  Future<AsyncValue<void>> deleteXPOfPrayer(
    Prayer prayer, {
    BuildContext? context,
  }) async {
    final int amount = prayer.xpHistory.target!.amount;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final xpRepository = ref.read(xPRepositoryProvider.notifier);
      await xpRepository.deleteXPOfPrayer(prayer);
    });

    // If successful then show snackbar if context is not null
    if (context != null && context.mounted && state.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reversed XP for prayer by $amount points")),
      );
    }

    return state;
  }

  /// Delete XP of Streak - reverses XP when streak is relapsed
  Future<AsyncValue<void>> deleteXPOfStreak(
    Streak streak, {
    BuildContext? context,
  }) async {
    final int amount = streak.xpHistory.target!.amount;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final xpRepository = ref.read(xPRepositoryProvider.notifier);
      await xpRepository.deleteXPOfStreak(streak);
    });

    // If successful then show snackbar if context is not null
    if (context != null && context.mounted && state.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reversed XP for streak by $amount points")),
      );
    }

    return state;
  }

  /// Delete XP of Temptation - reverses XP when temptation is undone
  Future<AsyncValue<void>> deleteXPOfTemptation(
    Temptation temptation, {
    BuildContext? context,
  }) async {
    final int amount = temptation.xpHistory.target!.amount;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final xpRepository = ref.read(xPRepositoryProvider.notifier);
      await xpRepository.deleteXPOfTemptation(temptation);
    });

    // If successful then show snackbar if context is not null
    if (context != null && context.mounted && state.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reversed XP for temptation by $amount points")),
      );
    }

    return state;
  }
}
