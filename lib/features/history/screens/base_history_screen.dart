import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

abstract class BaseHistoryScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const BaseHistoryScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

abstract class BaseHistoryScreenState<T extends BaseHistoryScreen>
    extends State<T> {
  bool _isLoading = true;
  String _searchQuery = '';
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Abstract methods to be implemented by subclasses
  Future<void> _loadData();
  Widget buildHistoryList();
  Widget buildEmptyState();
  List<Widget> buildFilterActions();

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    onSearchChanged(query);
  }

  void _onDateSelected(DateTime? date) {
    setState(() {
      _selectedDate = date;
    });
    onDateSelected(date);
  }

  // Virtual methods that can be overridden
  void onSearchChanged(String query) {}
  void onDateSelected(DateTime? date) {}
  void onRefresh() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.icon),
            onPressed: () {},
          ),
          ...buildFilterActions(),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search history...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                      vertical: AppConstants.spacingS,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: AppConstants.spacingM),
                // Date filter
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          _onDateSelected(date);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                        ),
                      ),
                    ),
                    if (_selectedDate != null) ...[
                      const SizedBox(width: AppConstants.spacingS),
                      IconButton(
                        onPressed: () => _onDateSelected(null),
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear date filter',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => onRefresh(),
                    child: buildHistoryList(),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper method to set loading state
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  // Helper method to get current search query
  String get searchQuery => _searchQuery;

  // Helper method to get selected date
  DateTime? get selectedDate => _selectedDate;
}
