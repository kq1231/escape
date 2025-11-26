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
  String? _filterType; // 'all', 'completed', 'missed'
  String? _prayerNameFilter; // 'all', 'Fajr', 'Dhuhr', etc.
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
      // Invalidate the provider to refresh data
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
        // Invalidate the provider to refresh data
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
        borderRadius: BorderRadius.circular(20.0),
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
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Exo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterDisplayText() {
    switch (_filterType) {
      case 'completed':
        return 'Completed Only';
      case 'missed':
        return 'Missed Only';
      default:
        return 'All Prayers';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the paginated prayer history provider
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
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Enhanced header with gradient
          Container(
            padding: const EdgeInsets.only(left: 24.0,right: 24, bottom: 16.0,top: 70),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryGreen.withOpacity(0.9),
                  AppConstants.primaryGreen.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryGreen.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Back button with improved design
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prayer History',
                        style: TextStyle(
                          fontFamily: 'Exo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedDate == null 
                            ? 'All Time Records'
                            : 'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Calendar button with improved design
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/schedule.png',
                      width: 22,
                      height: 22,
                      color: Colors.white,
                    ),
                    onPressed: _selectDate,
                  ),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 24.0),
      
          // Enhanced search and filter container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
              border: Border.all(
                color: AppConstants.primaryGreen.withOpacity(0.2),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryGreen.withOpacity(0.1),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search and filter row
                Row(
                  children: [
                    // Enhanced search field
                    Expanded(
                      child: Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Colors.grey[50],
                          border: Border.all(
                            color: AppConstants.primaryGreen.withOpacity(0.3),
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryGreen.withOpacity(0.05),
                              blurRadius: 10.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/search_icon.svg',
                              width: 22,
                              height: 22,
                              color: AppConstants.primaryGreen,
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  hintText: 'Search prayer records...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: _onSearchChanged,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Enhanced filter button
                    Container(
                      height: 56.0,
                      width: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppConstants.primaryGreen.withOpacity(0.9),
                            AppConstants.primaryGreen.withOpacity(0.7),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryGreen.withOpacity(0.3),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => _showCustomFilterMenu(context),
                        icon: Image.asset(
                          'assets/icons/filter.png',
                          width: 22,
                          height: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Enhanced prayer type filter
                SizedBox(
                  height: 56.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: _prayerTypes.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12.0),
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            gradient: isSelected 
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppConstants.primaryGreen.withOpacity(0.9),
                                      AppConstants.primaryGreen.withOpacity(0.7),
                                    ],
                                  )
                                : null,
                            color: isSelected ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: isSelected ? AppConstants.primaryGreen : AppConstants.primaryGreen.withOpacity(0.3),
                              width: isSelected ? 0 : 2.0,
                            ),
                            boxShadow: isSelected 
                                ? [
                                    BoxShadow(
                                      color: AppConstants.primaryGreen.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              prayerType,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppConstants.primaryGreen,
                                fontFamily: 'Exo',
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
      
          const SizedBox(height: 24.0),
      
          // History list with improved header
          Expanded(
            child: Column(
              children: [
                // Results header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Prayer Records',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontFamily: 'Exo',
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: prayerHistoryAsync.when(
                          loading: () => const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                          error: (error, stack) => const Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.errorRed,
                            ),
                          ),
                          data: (paginationState) {
                            final filteredPrayers = _filterPrayers(paginationState.items);
                            return Text(
                              '${filteredPrayers.length} records',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryGreen,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                // History list
                Expanded(
                  child: prayerHistoryAsync.when(
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryGreen),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading your prayer history...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: AppConstants.errorRed.withOpacity(0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Unable to load prayer history',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection and try again',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () => ref.invalidate(paginatedPrayerHistoryProvider),
                            child: const Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    data: (paginationState) {
                      final filteredPrayers = _filterPrayers(paginationState.items);
      
                      if (filteredPrayers.isEmpty && !paginationState.isLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mosque_outlined,
                                size: 100,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Prayer Records Found',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontFamily: 'Exo',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Start tracking your prayers to build your spiritual journey',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Start Tracking',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                          itemCount:
                              filteredPrayers.length +
                              (paginationState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the bottom
                            if (index == filteredPrayers.length) {
                              return const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryGreen),
                                  ),
                                ),
                              );
                            }
      
                            final prayer = filteredPrayers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: HistoryItemCard(
                                title: prayer.name,
                                subtitle: prayer.isCompleted ? 'Completed' : 'Missed',
                                date: prayer.date,
                                iconColor: prayer.isCompleted
                                    ? AppConstants.primaryGreen
                                    : AppConstants.errorRed,
                                isSuccess: prayer.isCompleted,
                                onEdit: () => _editPrayer(prayer),
                                onDelete: () => _deletePrayer(prayer),
                              ),
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppConstants.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Edit Prayer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Exo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Prayer Name',
                labelStyle: TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppConstants.primaryGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppConstants.primaryGreen.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppConstants.primaryGreen, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              value: _selectedPrayerName,
              items: _prayerNames.map((name) {
                return DropdownMenuItem(
                  value: name,
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPrayerName = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
            
              ),
              child: SwitchListTile(
                title: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: _isCompleted,
                activeColor: AppConstants.primaryGreen,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today, color: AppConstants.primaryGreen),
              ),
              title: const Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: AppConstants.primaryGreen, size: 16),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppConstants.primaryGreen),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
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
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}