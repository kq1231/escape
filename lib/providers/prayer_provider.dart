import 'package:escape/models/prayer_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/prayer_repository.dart';

part 'prayer_provider.g.dart';

/// A provider that handles all prayer-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@Riverpod(keepAlive: false)
class TodaysPrayers extends _$TodaysPrayers {
  @override
  Stream<List<Prayer>> build([DateTime? date]) async* {
    Stream<List<Prayer>> stream = ref
        .watch(prayerRepositoryProvider.notifier)
        .watchPrayers();

    // Watch the prayer repository for changes
    yield* stream;
  }

  /// Toggle the completion status of a prayer
  Future<void> togglePrayerCompletion(int prayerId) async {
    await ref
        .read(prayerRepositoryProvider.notifier)
        .togglePrayerCompletion(prayerId);
  }

  /// Delete a prayer
  Future<bool> deletePrayer(int id) async {
    return await ref.read(prayerRepositoryProvider.notifier).deletePrayer(id);
  }
}
