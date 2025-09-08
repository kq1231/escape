import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/analytics_models.dart';

class TimeRangeFilter extends StatefulWidget {
  final AnalyticsTimeRange? initialRange;
  final Function(AnalyticsTimeRange?) onRangeChanged;

  const TimeRangeFilter({
    super.key,
    this.initialRange,
    required this.onRangeChanged,
  });

  @override
  State<TimeRangeFilter> createState() => _TimeRangeFilterState();
}

class _TimeRangeFilterState extends State<TimeRangeFilter> {
  AnalyticsTimeRange? _selectedRange;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter button
        Container(
          decoration: BoxDecoration(
            color: AppConstants.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(color: AppConstants.lightGray),
            boxShadow: AppConstants.cardShadow,
          ),
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(
              Icons.filter_list,
              color: AppConstants.primaryGreen,
              size: 20,
            ),
            label: Text(
              _selectedRange?.label ?? 'Select Time Range',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingS,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),

        // Filter options
        if (_isExpanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(top: AppConstants.spacingM),
            decoration: BoxDecoration(
              color: AppConstants.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: AppConstants.lightGray),
              boxShadow: AppConstants.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick filter options
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: Text(
                    'Quick Filters',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.darkGreen,
                    ),
                  ),
                ),

                // Quick filter buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingM,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildQuickFilterButton(
                        'This Week',
                        AnalyticsTimeRange.currentWeek(),
                      ),
                      _buildQuickFilterButton(
                        'This Month',
                        AnalyticsTimeRange.currentMonth(),
                      ),
                      _buildQuickFilterButton(
                        'This Year',
                        AnalyticsTimeRange.currentYear(),
                      ),
                      _buildQuickFilterButton(
                        'Last 7 Days',
                        AnalyticsTimeRange.lastDays(7),
                      ),
                      _buildQuickFilterButton(
                        'Last 30 Days',
                        AnalyticsTimeRange.lastDays(30),
                      ),
                      _buildQuickFilterButton(
                        'Last 90 Days',
                        AnalyticsTimeRange.lastDays(90),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: AppConstants.lightGray),

                // Custom range option
                ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: AppConstants.primaryGreen,
                    size: 20,
                  ),
                  title: Text(
                    'Custom Date Range',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _showCustomRangePicker();
                  },
                ),

                // Clear filter option
                if (_selectedRange != null)
                  ListTile(
                    leading: const Icon(
                      Icons.clear,
                      color: AppConstants.errorRed,
                      size: 20,
                    ),
                    title: Text(
                      'Clear Filter',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.errorRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedRange = null;
                        widget.onRangeChanged(null);
                        _isExpanded = false;
                      });
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickFilterButton(String label, AnalyticsTimeRange range) {
    final isSelected = _selectedRange?.label == range.label;

    return FilterChip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected ? AppConstants.white : AppConstants.darkGreen,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedRange = selected ? range : null;
          widget.onRangeChanged(selected ? range : null);
          _isExpanded = false;
        });
      },
      backgroundColor: AppConstants.lightGray,
      selectedColor: AppConstants.primaryGreen,
      checkmarkColor: AppConstants.white,
      pressElevation: 2,
    );
  }

  Future<void> _showCustomRangePicker() async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryGreen,
              onPrimary: AppConstants.white,
              surface: AppConstants.white,
              onSurface: AppConstants.darkGreen,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryGreen,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      // Use the selected date range
      final customRange = AnalyticsTimeRange(
        start: pickedRange.start,
        end: pickedRange.end,
        label: 'Custom Range',
      );

      setState(() {
        _selectedRange = customRange;
        widget.onRangeChanged(customRange);
        _isExpanded = false;
      });
    }
  }
}
