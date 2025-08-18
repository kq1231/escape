import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TemptationStorageService {
  static const String activeTemptationId = 'active_temptation_id';
  static const String temptationStartTime = 'temptation_start_time';
  static const String selectedActivity = 'selected_activity';
  static const String intensityBefore = 'intensity_before';
  static const String triggers = 'triggers';
  static const String createdAt = 'created_at';

  static final TemptationStorageService _instance =
      TemptationStorageService._internal();
  factory TemptationStorageService() => _instance;
  TemptationStorageService._internal();

  late SharedPreferences _prefs;
  final Completer<void> _prefsInitialized = Completer();

  Future<void> initialize() async {
    if (!_prefsInitialized.isCompleted) {
      _prefs = await SharedPreferences.getInstance();
      _prefsInitialized.complete();
    }
  }

  bool get isInitialized => _prefsInitialized.isCompleted;

  // Store active temptation data
  Future<void> storeActiveTemptation({
    required int temptationId,
    required DateTime startTime,
    String? selectedActivity,
    int? intensityBefore,
    List<String>? triggers,
  }) async {
    await _prefsInitialized.future;

    await Future.wait([
      _prefs.setInt(activeTemptationId, temptationId),
      _prefs.setString(temptationStartTime, startTime.toIso8601String()),
      _prefs.setString(createdAt, startTime.toIso8601String()),
      if (selectedActivity != null)
        _prefs.setString(
          TemptationStorageService.selectedActivity,
          selectedActivity,
        ),
      if (intensityBefore != null)
        _prefs.setInt(
          TemptationStorageService.intensityBefore,
          intensityBefore,
        ),
      if (triggers != null && triggers.isNotEmpty)
        _prefs.setStringList(TemptationStorageService.triggers, triggers),
    ]);
  }

  // Get active temptation ID
  int? getActiveTemptationId() {
    return _prefs.getInt(activeTemptationId);
  }

  // Get temptation start time
  DateTime? getTemptationStartTime() {
    final timeString = _prefs.getString(temptationStartTime);
    return timeString != null ? DateTime.parse(timeString) : null;
  }

  // Get selected activity
  String? getSelectedActivity() {
    return _prefs.getString(selectedActivity);
  }

  // Get intensity before
  int? getIntensityBefore() {
    return _prefs.getInt(intensityBefore);
  }

  // Get triggers
  List<String> getTriggers() {
    return _prefs.getStringList(triggers) ?? [];
  }

  // Get created at
  DateTime? getCreatedAt() {
    final timeString = _prefs.getString(createdAt);
    return timeString != null ? DateTime.parse(timeString) : null;
  }

  // Check if there's an active temptation
  bool hasActiveTemptation() {
    return _prefs.containsKey(activeTemptationId);
  }

  // Clear active temptation data
  Future<void> clearActiveTemptation() async {
    await _prefsInitialized.future;

    await Future.wait([
      _prefs.remove(activeTemptationId),
      _prefs.remove(temptationStartTime),
      _prefs.remove(selectedActivity),
      _prefs.remove(intensityBefore),
      _prefs.remove(triggers),
      _prefs.remove(createdAt),
    ]);
  }

  // Update selected activity
  Future<void> updateSelectedActivity(String activity) async {
    await _prefsInitialized.future;
    await _prefs.setString(selectedActivity, activity);
  }

  // Update intensity before
  Future<void> updateIntensityBefore(int intensity) async {
    await _prefsInitialized.future;
    await _prefs.setInt(intensityBefore, intensity);
  }

  // Add trigger
  Future<void> addTrigger(String trigger) async {
    await _prefsInitialized.future;
    final triggers = getTriggers();
    if (!triggers.contains(trigger)) {
      triggers.add(trigger);
      await _prefs.setStringList(TemptationStorageService.triggers, triggers);
    }
  }

  // Remove trigger
  Future<void> removeTrigger(String trigger) async {
    await _prefsInitialized.future;
    final triggers = getTriggers();
    triggers.remove(trigger);
    await _prefs.setStringList(TemptationStorageService.triggers, triggers);
  }

  // Get temptation duration
  Duration? getTemptationDuration() {
    final startTime = getTemptationStartTime();
    if (startTime == null) return null;
    return DateTime.now().difference(startTime);
  }

  // Get formatted duration string
  String? getFormattedDuration() {
    final duration = getTemptationDuration();
    if (duration == null) return null;

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Check if temptation is still active (within reasonable time frame)
  bool isTemptationStillActive({
    Duration maxDuration = const Duration(hours: 2),
  }) {
    final startTime = getTemptationStartTime();
    if (startTime == null) return false;

    final elapsed = DateTime.now().difference(startTime);
    return elapsed < maxDuration;
  }

  // Get temptation data as map
  Map<String, dynamic> getTemptationData() {
    return {
      'id': getActiveTemptationId(),
      'startTime': getTemptationStartTime()?.toIso8601String(),
      'selectedActivity': getSelectedActivity(),
      'intensityBefore': getIntensityBefore(),
      'triggers': getTriggers(),
      'createdAt': getCreatedAt()?.toIso8601String(),
      'duration': getFormattedDuration(),
      'isStillActive': isTemptationStillActive(),
    };
  }

  // Clear all temptation-related data
  Future<void> clearAllTemptationData() async {
    await _prefsInitialized.future;

    final keys = [
      activeTemptationId,
      temptationStartTime,
      selectedActivity,
      intensityBefore,
      triggers,
      createdAt,
    ];

    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
