import 'package:escape/models/timings_model.dart';
import 'package:escape/models/xp_history_item_model.dart';
import 'package:escape/providers/prayer_provider.dart';
import 'package:escape/providers/prayer_timing_provider.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/providers/xp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../molecules/prayer_row.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';

class DailyPrayerGrid extends ConsumerWidget {
  final Function(Prayer, CheckboxState)? onPrayerStateChanged;
  final VoidCallback? onPrayerTap;

  const DailyPrayerGrid({
    super.key,
    this.onPrayerStateChanged,
    this.onPrayerTap,
  });

  int _getXPForPrayer(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
      case 'Asr':
        return 300;
      case 'Tahajjud':
        return 5000;
      case 'Dhuhr':
      case 'Maghrib':
      case 'Isha':
        return 100;
      default:
        return 100;
    }
  }

  String? _getPrayerTime(String prayerName, PrayerTimes? prayerTimes) {
    if (prayerTimes == null) return null;
    switch (prayerName) {
      case 'Fajr':
        return prayerTimes.timings.fajr;
      case 'Dhuhr':
        return prayerTimes.timings.dhuhr;
      case 'Asr':
        return prayerTimes.timings.asr;
      case 'Maghrib':
        return prayerTimes.timings.maghrib;
      case 'Isha':
        return prayerTimes.timings.isha;
      default:
        return null;
    }
  }

  String? _computeNextPrayer(List<String> prayerNames, PrayerTimes? prayerTimes) {
    if (prayerTimes == null) return null;
    final now = TimeOfDay.now();
    for (final name in prayerNames) {
      if (name == 'Tahajjud') continue;
      final timeStr = _getPrayerTime(name, prayerTimes);
      if (timeStr == null) continue;
      final parts = timeStr.split(':');
      final target = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      if (now.hour < target.hour || (now.hour == target.hour && now.minute < target.minute)) {
        return name;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());
    final prayerTimingAsync = ref.watch(prayerTimingProvider);

    return todaysPrayersAsync.when(
      data: (prayers) {
        final List<String> prayerNames = [
          'Tahajjud',
          'Fajr',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];
        final Map<String, Prayer> prayerMap = {for (var p in prayers) p.name: p};

        PrayerTimes? prayerTimes;
        bool showRetryButton = false;

        if (prayerTimingAsync is AsyncData) {
          prayerTimes = prayerTimingAsync.value;
        } else if (prayerTimingAsync is AsyncError) {
          showRetryButton = true;
        }

        final nextPrayerName = _computeNextPrayer(prayerNames, prayerTimes);

        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppConstants.black
                : AppConstants.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppConstants.lightGray),
            boxShadow: AppConstants.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // <-- align start
            children: [
              // Title aligned to start
              Text(
                'Today\'s Prayers',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Exo',
                    ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppConstants.spacingM),
              ...prayerNames.map((name) {
                final prayer = prayerMap[name];
                final isNext = name == nextPrayerName;

                return Column(
                  children: [
                    PrayerRow(
                      prayerName: name,
                      prayer: prayer,
                      xp: _getXPForPrayer(name),
                      time: name != 'Tahajjud' ? _getPrayerTime(name, prayerTimes) : null,
                      onStateChanged: (state) async {
                        await _handlePrayerStateChange(name, prayer, state, ref, context);
                      },
                      onTap: () => onPrayerTap?.call(),
                    ),
                    if (name != prayerNames.last)
                      const SizedBox(height: AppConstants.spacingS),
                  ],
                );
              }),
              if (showRetryButton) ...[
                const SizedBox(height: AppConstants.spacingM),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(prayerTimingProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Loading Prayer Times'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Future<void> _handlePrayerStateChange(
    String prayerName,
    Prayer? prayer,
    CheckboxState state,
    WidgetRef ref,
    BuildContext context,
  ) async {
    switch (state) {
      case CheckboxState.checked:
        int xpAmount = _getXPForPrayer(prayerName);
        XPHistoryItem xpHistoryItem = await ref.read(xPControllerProvider.notifier).createXP(
              xpAmount,
              'Completed $prayerName prayer',
              context: context,
            );
        if (prayer == null) {
          final newPrayer = Prayer(
            name: prayerName,
            isCompleted: true,
            date: DateTime.now(),
          )..xpHistory.target = xpHistoryItem;
          ref.read(prayerRepositoryProvider.notifier).createPrayer(newPrayer);
        } else {
          ref.read(prayerRepositoryProvider.notifier).updatePrayer(prayer.copyWith(isCompleted: true));
        }
        break;
      case CheckboxState.unchecked:
        if (prayer!.id == 0) {
          final newPrayer = Prayer(
            name: prayer.name,
            isCompleted: false,
            date: DateTime.now(),
          );
          ref.read(prayerRepositoryProvider.notifier).createPrayer(newPrayer);
        } else {
          ref.read(prayerRepositoryProvider.notifier).updatePrayer(prayer.copyWith(isCompleted: false));
          await ref.read(xPControllerProvider.notifier).deleteXPOfPrayer(prayer, context: context);
        }
        break;
      case CheckboxState.empty:
        if (prayer!.id != 0) {
          ref.read(prayerRepositoryProvider.notifier).deletePrayer(prayer.id);
        }
        break;
    }
  }
}
