import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/temptation_model.dart';
import 'package:escape/providers/history_providers.dart';
import 'package:escape/repositories/temptation_repository.dart';
import '../widgets/history_item_card.dart';

class TemptationHistoryScreen extends ConsumerStatefulWidget {
  const TemptationHistoryScreen({super.key});

  @override
  ConsumerState<TemptationHistoryScreen> createState() =>
      _TemptationHistoryScreenState();
}

class _TemptationHistoryScreenState
    extends ConsumerState<TemptationHistoryScreen> {
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _filterType; // 'all', 'successful', 'relapsed'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Temptation> _filterTemptations(List<Temptation> temptations) {
    var filtered = temptations;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((temptation) {
        return (temptation.selectedActivity?.toLowerCase().contains(query) ??
                false) ||
            temptation.wasSuccessful.toString().toLowerCase().contains(query) ||
            temptation.triggers.any(
              (trigger) => trigger.toLowerCase().contains(query),
            );
      }).toList();
    }

    // Apply success filter
    if (_filterType != null && _filterType != 'all') {
      if (_filterType == 'successful') {
        filtered = filtered
            .where((temptation) => temptation.wasSuccessful)
            .toList();
      } else if (_filterType == 'relapsed') {
        filtered = filtered
            .where((temptation) => !temptation.wasSuccessful)
            .toList();
      }
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
      ref.invalidate(paginatedTemptationHistoryProvider);
    }
  }

  Future<void> _editTemptation(Temptation temptation) async {
    final result = await showDialog<Temptation>(
      context: context,
      builder: (context) => _EditTemptationDialog(temptation: temptation),
    );

    if (result != null) {
      try {
        final temptationRepository = ref.read(
          temptationRepositoryProvider.notifier,
        );
        await temptationRepository.updateTemptation(result);
        // Invalidate the provider to refresh data
        ref.invalidate(temptationHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Temptation updated successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating temptation: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteTemptation(Temptation temptation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Temptation'),
        content: Text(
          'Are you sure you want to delete this temptation record for ${temptation.selectedActivity}?',
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
        final temptationRepository = ref.read(
          temptationRepositoryProvider.notifier,
        );
        await temptationRepository.deleteTemptation(temptation.id);
        // Invalidate the provider to refresh data
        ref.invalidate(paginatedTemptationHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Temptation deleted successfully'),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting temptation: $e'),
              backgroundColor: AppConstants.errorRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the paginated temptation history provider
    final temptationHistoryAsync = ref.watch(
      paginatedTemptationHistoryProvider(
        startDate: _selectedDate,
        endDate: _selectedDate,
        wasSuccessful: _filterType == 'successful'
            ? true
            : _filterType == 'relapsed'
            ? false
            : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temptation History'),
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
              const PopupMenuItem(value: 'all', child: Text('All Temptations')),
              const PopupMenuItem(
                value: 'successful',
                child: Text('Successful Only'),
              ),
              const PopupMenuItem(
                value: 'relapsed',
                child: Text('Relapses Only'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar and filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search temptations...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),

          // History list
          Expanded(
            child: temptationHistoryAsync.when(
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
                    Text('Error loading temptation history: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(paginatedTemptationHistoryProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (paginationState) {
                final filteredTemptations = _filterTemptations(
                  paginationState.items,
                );

                if (filteredTemptations.isEmpty && !paginationState.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No temptation records found'),
                        SizedBox(height: 8),
                        Text(
                          'Start tracking your temptations to see them here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    // Load more when user scrolls to bottom
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        paginationState.hasMore &&
                        !paginationState.isLoading) {
                      ref
                          .read(
                            paginatedTemptationHistoryProvider(
                              startDate: _selectedDate,
                              endDate: _selectedDate,
                              wasSuccessful: _filterType == 'successful'
                                  ? true
                                  : _filterType == 'relapsed'
                                  ? false
                                  : null,
                            ).notifier,
                          )
                          .loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount:
                        filteredTemptations.length +
                        (paginationState.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom
                      if (index == filteredTemptations.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final temptation = filteredTemptations[index];
                      return HistoryItemCard(
                        title:
                            temptation.selectedActivity ?? 'Unknown Activity',
                        subtitle: temptation.wasSuccessful
                            ? 'Resisted Successfully'
                            : 'Relapsed',
                        date: temptation.createdAt,
                        icon: temptation.wasSuccessful
                            ? Icons.check_circle
                            : Icons.cancel,
                        iconColor: temptation.wasSuccessful
                            ? AppConstants.primaryGreen
                            : AppConstants.errorRed,
                        isSuccess: temptation.wasSuccessful,
                        additionalInfo: [
                          if (temptation.triggers.isNotEmpty)
                            Text(
                              'Triggers: ${temptation.triggers.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (temptation.helpfulActivities.isNotEmpty)
                            Text(
                              'Helpful: ${temptation.helpfulActivities.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                        onEdit: () => _editTemptation(temptation),
                        onDelete: () => _deleteTemptation(temptation),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTemptationDialog extends StatefulWidget {
  final Temptation temptation;

  const _EditTemptationDialog({required this.temptation});

  @override
  State<_EditTemptationDialog> createState() => _EditTemptationDialogState();
}

class _EditTemptationDialogState extends State<_EditTemptationDialog> {
  late String _selectedActivity;
  late bool _wasSuccessful;
  late DateTime _selectedDate;
  late List<String> _triggers;
  late List<String> _helpfulActivities;

  final List<String> _activities = [
    'Reading Quran',
    'Prayer',
    'Exercise',
    'Walk',
    'Call Friend',
    'Meditation',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedActivity = widget.temptation.selectedActivity ?? 'Other';
    _wasSuccessful = widget.temptation.wasSuccessful;
    _selectedDate = widget.temptation.createdAt;
    _triggers = List.from(widget.temptation.triggers);
    _helpfulActivities = List.from(widget.temptation.helpfulActivities);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Temptation'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedActivity,
              decoration: const InputDecoration(
                labelText: 'Activity',
                border: OutlineInputBorder(),
              ),
              items: _activities.map((activity) {
                return DropdownMenuItem(value: activity, child: Text(activity));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedActivity = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Was Successful'),
              value: _wasSuccessful,
              onChanged: (value) {
                setState(() {
                  _wasSuccessful = value;
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTemptation = Temptation(
              id: widget.temptation.id,
              selectedActivity: _selectedActivity,
              triggers: _triggers,
              helpfulActivities: _helpfulActivities,
              wasSuccessful: _wasSuccessful,
              createdAt: _selectedDate,
            );
            Navigator.of(context).pop(updatedTemptation);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
