import 'package:escape/features/temptation/services/temptation_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'has_active_temptation_provider.g.dart';

/// Provider to check if there's an active temptation
/// Used in AppStartupSuccessWidget to determine whether to show the banner
/// keepAlive: true because it's used during app startup and should persist
@Riverpod(keepAlive: true)
class HasActiveTemptation extends _$HasActiveTemptation {
  late TemptationStorageService _storageService;

  @override
  bool build() {
    // Initialize the storage service
    _storageService = TemptationStorageService();
    _storageService.initialize();

    // Check if there's an active temptation in SharedPreferences
    return _storageService.hasActiveTemptation();
  }

  /// Method to refresh the provider state
  void refresh() {
    ref.invalidateSelf();
  }
}
