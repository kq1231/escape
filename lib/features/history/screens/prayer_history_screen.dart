import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/prayer_model.dart';
import 'package:escape/providers/history_providers.dart';
import 'package:escape/repositories/prayer_repository.dart';
import '../widgets/history_item_card.dart';

class PrayerHistoryScreen extends ConsumerStatefulWidget {
  const PrayerHistoryScreen({super.key});

  @override
  ConsumerState<PrayerHistoryScreen> createState() =>
      _PrayerHistoryScreenState();
}

class _PrayerHistoryScreenState extends ConsumerState<PrayerHistoryScreen> {
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _filterType; // 'all', 'completed', 'missed'
  String? _prayerNameFilter; // 'all', 'Fajr', 'Dhuhr', etc.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Prayer> _filterPrayers(List<Prayer> prayers) {
    var filtered = prayers;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((prayer) {
        return prayer.name.toLowerCase().contains(query) ||
            prayer.isCompleted.toString().toLowerCase().contains(query);
      }).toList();
    }

    // Apply completion filter
    if (_filterType != null && _filterType != 'all') {
      if (_filterType == 'completed') {
        filtered = filtered.where((prayer) => prayer.isCompleted).toList();
      } else if (_filterType == 'missed') {
        filtered = filtered.where((prayer) => !prayer.isCompleted).toList();
      }
    }

    // Apply prayer name filter
    if (_prayerNameFilter != null && _prayerNameFilter != 'all') {
      filtered = filtered
          .where((prayer) => prayer.name == _prayerNameFilter)
          .toList();
    }

    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
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
      ref.invalidate(prayerHistoryProvider);
    }
  }

  Future<void> _editPrayer(Prayer prayer) async {
    final result = await showDialog<Prayer>(
      context: context,
      builder: (context) => _EditPrayerDialog(prayer: prayer),
    );

    if (result != null) {
      try {
        final prayerRepository = ref.read(prayerRepositoryProvider.notifier);
        await prayerRepository.updatePrayer(result);
        // Invalidate the provider to refresh data
        ref.invalidate(prayerHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prayer updated successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating prayer: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _deletePrayer(Prayer prayer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prayer'),
        content: Text(
          'Are you sure you want to delete the ${prayer.name} prayer record?',
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
        final prayerRepository = ref.read(prayerRepositoryProvider.notifier);
        await prayerRepository.deletePrayer(prayer.id);
        // Invalidate the provider to refresh data
        ref.invalidate(prayerHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prayer deleted successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting prayer: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the prayer history provider
    final prayerHistoryAsync = ref.watch(
      prayerHistoryProvider(
        limit: 100,
        startDate: _selectedDate,
        endDate: _selectedDate,
        prayerName: _prayerNameFilter != 'all' ? _prayerNameFilter : null,
        isCompleted: _filterType == 'completed'
            ? true
            : _filterType == 'missed'
            ? false
            : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer History'),
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
              const PopupMenuItem(value: 'all', child: Text('All Prayers')),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed Only'),
              ),
              const PopupMenuItem(value: 'missed', child: Text('Missed Only')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar and prayer filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search prayers...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _prayerNameFilter,
                  decoration: const InputDecoration(
                    labelText: 'Prayer Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Prayers')),
                    DropdownMenuItem(
                      value: 'Tahajjud',
                      child: Text('Tahajjud'),
                    ),
                    DropdownMenuItem(value: 'Fajr', child: Text('Fajr')),
                    DropdownMenuItem(value: 'Dhuhr', child: Text('Dhuhr')),
                    DropdownMenuItem(value: 'Asr', child: Text('Asr')),
                    DropdownMenuItem(value: 'Maghrib', child: Text('Maghrib')),
                    DropdownMenuItem(value: 'Isha', child: Text('Isha')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _prayerNameFilter = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // History list
          Expanded(
            child: prayerHistoryAsync.when(
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
                    Text('Error loading prayer history: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(prayerHistoryProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (prayers) {
                final filteredPrayers = _filterPrayers(prayers);

                if (filteredPrayers.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mosque, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No prayer records found'),
                        SizedBox(height: 8),
                        Text(
                          'Start tracking your prayers to see them here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredPrayers.length,
                  itemBuilder: (context, index) {
                    final prayer = filteredPrayers[index];
                    return HistoryItemCard(
                      title: prayer.name,
                      subtitle: prayer.isCompleted ? 'Completed' : 'Missed',
                      date: prayer.date,
                      icon: prayer.isCompleted
                          ? Icons.check_circle
                          : Icons.cancel,
                      iconColor: prayer.isCompleted
                          ? AppConstants.primaryGreen
                          : AppConstants.errorRed,
                      isSuccess: prayer.isCompleted,
                      onEdit: () => _editPrayer(prayer),
                      onDelete: () => _deletePrayer(prayer),
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

class _EditPrayerDialog extends StatefulWidget {
  final Prayer prayer;

  const _EditPrayerDialog({required this.prayer});

  @override
  State<_EditPrayerDialog> createState() => _EditPrayerDialogState();
}

class _EditPrayerDialogState extends State<_EditPrayerDialog> {
  late String _selectedPrayerName;
  late bool _isCompleted;
  late DateTime _selectedDate;

  final List<String> _prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  void initState() {
    super.initState();
    _selectedPrayerName = widget.prayer.name;
    _isCompleted = widget.prayer.isCompleted;
    _selectedDate = widget.prayer.date;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Prayer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedPrayerName,
            decoration: const InputDecoration(
              labelText: 'Prayer Name',
              border: OutlineInputBorder(),
            ),
            items: _prayerNames.map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPrayerName = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Completed'),
            value: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value;
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
                  _selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    _selectedDate.hour,
                    _selectedDate.minute,
                  );
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
            final updatedPrayer = Prayer(
              id: widget.prayer.id,
              name: _selectedPrayerName,
              date: _selectedDate,
              isCompleted: _isCompleted,
            );
            Navigator.of(context).pop(updatedPrayer);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
