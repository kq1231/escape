import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/streak_model.dart';
import 'package:escape/providers/history_providers.dart';
import 'package:escape/repositories/streak_repository.dart';
import '../widgets/history_item_card.dart';

class StreakHistoryScreen extends ConsumerStatefulWidget {
  const StreakHistoryScreen({super.key});

  @override
  ConsumerState<StreakHistoryScreen> createState() =>
      _StreakHistoryScreenState();
}

class _StreakHistoryScreenState extends ConsumerState<StreakHistoryScreen> {
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _filterType; // 'all', 'success', 'relapse'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Streak> _filterStreaks(List<Streak> streaks) {
    var filtered = streaks;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((streak) {
        return streak.count.toString().contains(query) ||
            streak.isSuccess.toString().toLowerCase().contains(query);
      }).toList();
    }

    // Apply type filter
    if (_filterType != null && _filterType != 'all') {
      if (_filterType == 'success') {
        filtered = filtered.where((streak) => streak.isSuccess).toList();
      } else if (_filterType == 'relapse') {
        filtered = filtered.where((streak) => !streak.isSuccess).toList();
      }
    }

    return filtered;
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      // Invalidate the provider to refresh data
      ref.invalidate(streakHistoryProvider);
    }
  }

  Future<void> _editStreak(Streak streak) async {
    final result = await showDialog<Streak>(
      context: context,
      builder: (context) => _EditStreakDialog(streak: streak),
    );

    if (result != null) {
      try {
        final streakRepository = ref.read(streakRepositoryProvider.notifier);
        await streakRepository.updateStreak(result);
        // Invalidate the provider to refresh data
        ref.invalidate(streakHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Streak updated successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating streak: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteStreak(Streak streak) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Streak'),
        content: Text(
          'Are you sure you want to delete the streak record for ${streak.date.day}/${streak.date.month}/${streak.date.year}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppConstants.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final streakRepository = ref.read(streakRepositoryProvider.notifier);
        await streakRepository.deleteStreak(streak.id);
        // Invalidate the provider to refresh data
        ref.invalidate(streakHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Streak deleted successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting streak: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the streak history provider
    final streakHistoryAsync = ref.watch(
      streakHistoryProvider(
        limit: 100,
        startDate: _selectedDate,
        endDate: _selectedDate,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Streaks')),
              const PopupMenuItem(
                value: 'success',
                child: Text('Successful Only'),
              ),
              const PopupMenuItem(
                value: 'relapse',
                child: Text('Relapses Only'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // History list
          Expanded(
            child: streakHistoryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: AppConstants.errorRed,
                    ),
                    const SizedBox(height: 16),
                    Text('Error loading streak history: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(streakHistoryProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (streaks) {
                final filteredStreaks = _filterStreaks(streaks);

                if (filteredStreaks.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No streak records found'),
                        SizedBox(height: 8),
                        Text(
                          'Start tracking your streaks to see them here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredStreaks.length,
                  itemBuilder: (context, index) {
                    final streak = filteredStreaks[index];
                    return HistoryItemCard(
                      title: 'Day ${streak.count}',
                      subtitle: streak.isSuccess ? 'Successful' : 'Relapse',
                      date: streak.date,
                      icon: streak.isSuccess
                          ? Icons.check_circle
                          : Icons.cancel,
                      iconColor: streak.isSuccess
                          ? AppConstants.primaryGreen
                          : AppConstants.errorRed,
                      isSuccess: streak.isSuccess,
                      onEdit: () => _editStreak(streak),
                      onDelete: () => _deleteStreak(streak),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditStreakDialog extends StatefulWidget {
  final Streak streak;

  const _EditStreakDialog({required this.streak});

  @override
  State<_EditStreakDialog> createState() => _EditStreakDialogState();
}

class _EditStreakDialogState extends State<_EditStreakDialog> {
  late TextEditingController _countController;
  late bool _isSuccess;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _countController = TextEditingController(
      text: widget.streak.count.toString(),
    );
    _isSuccess = widget.streak.isSuccess;
    _selectedDate = widget.streak.date;
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Streak'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _countController,
            decoration: const InputDecoration(
              labelText: 'Count',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Successful'),
            value: _isSuccess,
            onChanged: (value) {
              setState(() {
                _isSuccess = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Date'),
            subtitle: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final count = int.tryParse(_countController.text);
            if (count != null) {
              final updatedStreak = Streak(
                id: widget.streak.id,
                count: count,
                date: _selectedDate,
                isSuccess: _isSuccess,
              );
              Navigator.of(context).pop(updatedStreak);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
