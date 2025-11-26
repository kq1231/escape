import 'package:escape/models/prayer_model.dart';
import 'package:escape/providers/history_providers.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  String? _filterType;
  String? _prayerNameFilter; 
  final TextEditingController _searchController = TextEditingController();

  final List<String> _prayerTypes = [
    'All Prayers',
    'Tahajjud',
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha'
  ];

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
      ref.invalidate(paginatedPrayerHistoryProvider);
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
        ref.invalidate(paginatedPrayerHistoryProvider);

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

  void _showCustomFilterMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: AppConstants.primaryGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      items: [
        _buildCustomPopupMenuItem('All Prayers', 'all', Icons.all_inclusive),
        _buildCustomPopupMenuItem('Completed Only', 'completed', Icons.check_circle),
        _buildCustomPopupMenuItem('Missed Only', 'missed', Icons.cancel),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          _filterType = value;
        });
      }
    });
  }

  PopupMenuItem<String> _buildCustomPopupMenuItem(String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppConstants.primaryGreen,
            ),
            const SizedBox(width: 12.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final prayerHistoryAsync = ref.watch(
      paginatedPrayerHistoryProvider(
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: AppConstants.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryGreen.withOpacity(0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Prayer History',
                    style: TextStyle(
                      fontFamily: 'Exo',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: AppConstants.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryGreen.withOpacity(0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/schedule.png',
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                      onPressed: _selectDate,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.7),
                border: Border.all(
                  color: AppConstants.primaryGreen.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    blurRadius: 15.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white.withOpacity(0.9),
                            border: Border.all(
                              color: AppConstants.primaryGreen.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.primaryGreen.withOpacity(0.05),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/search_icon.svg',
                                width: 20,
                                height: 20,
                                color: AppConstants.primaryGreen,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Search prayers...',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: _onSearchChanged,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: AppConstants.primaryGreen,
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryGreen.withOpacity(0.05),
                              blurRadius: 6.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => _showCustomFilterMenu(context),
                          icon: Image.asset(
                            'assets/icons/filter.png',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 50.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      itemCount: _prayerTypes.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                      itemBuilder: (context, index) {
                        final prayerType = _prayerTypes[index];
                        final isSelected = _prayerNameFilter == (prayerType == 'All Prayers' ? 'all' : prayerType) ||
                            (_prayerNameFilter == null && prayerType == 'All Prayers');
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _prayerNameFilter = prayerType == 'All Prayers' ? 'all' : prayerType;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: isSelected ? AppConstants.primaryGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0), 
                              border: Border.all(
                                color: isSelected ? AppConstants.primaryGreen : AppConstants.primaryGreen.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                prayerType,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.white : AppConstants.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => ref.invalidate(paginatedPrayerHistoryProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (paginationState) {
                  final filteredPrayers = _filterPrayers(paginationState.items);

                  if (filteredPrayers.isEmpty && !paginationState.isLoading) {
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

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          paginationState.hasMore &&
                          !paginationState.isLoading) {
                        ref
                            .read(
                              paginatedPrayerHistoryProvider(
                                startDate: _selectedDate,
                                endDate: _selectedDate,
                                prayerName: _prayerNameFilter != 'all'
                                    ? _prayerNameFilter
                                    : null,
                                isCompleted: _filterType == 'completed'
                                    ? true
                                    : _filterType == 'missed'
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
                          filteredPrayers.length +
                          (paginationState.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredPrayers.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final prayer = filteredPrayers[index];
                        return HistoryItemCard(
                          title: prayer.name,
                          subtitle: prayer.isCompleted ? 'Completed' : 'Missed',
                          date: prayer.date,
                          iconColor: prayer.isCompleted
                              ? AppConstants.primaryGreen
                              : AppConstants.errorRed,
                          isSuccess: prayer.isCompleted,
                          onEdit: () => _editPrayer(prayer),
                          onDelete: () => _deletePrayer(prayer),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
            decoration: InputDecoration(
              labelText: 'Prayer Name',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppConstants.primaryGreen),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppConstants.primaryGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppConstants.primaryGreen),
              ),
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
            activeColor: AppConstants.primaryGreen,
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
            trailing: Icon(Icons.calendar_today, color: AppConstants.primaryGreen),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryGreen,
            foregroundColor: Colors.white,
          ),
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