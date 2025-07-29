import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

enum CheckboxState {
  checked, // Prayer completed
  unchecked, // Prayer not completed
  empty, // Prayer not recorded/deleted
}

class TripleStateCheckbox extends StatefulWidget {
  final CheckboxState state;
  final ValueChanged<CheckboxState>? onChanged;
  final double size;
  final int tapCount; // Track tap count for this specific checkbox

  const TripleStateCheckbox({
    super.key,
    this.state = CheckboxState.empty,
    this.onChanged,
    this.size = 24.0,
    this.tapCount = 0,
  });

  @override
  State<TripleStateCheckbox> createState() => _TripleStateCheckboxState();
}

class _TripleStateCheckboxState extends State<TripleStateCheckbox> {
  late int _tapCount;

  @override
  void initState() {
    super.initState();
    _tapCount = widget.tapCount;
  }

  @override
  void didUpdateWidget(covariant TripleStateCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tapCount != widget.tapCount) {
      _tapCount = widget.tapCount;
    }
  }

  void _handleTap() {
    if (widget.onChanged == null) return;

    setState(() {
      _tapCount++;
    });

    // Cycle through states based on tap count
    switch (_tapCount % 3) {
      case 1: // First tap - checked
        widget.onChanged!(CheckboxState.checked);
        break;
      case 2: // Second tap - unchecked
        widget.onChanged!(CheckboxState.unchecked);
        break;
      case 0: // Third tap - empty (reset)
        widget.onChanged!(CheckboxState.empty);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
          border: Border.all(color: _getBorderColor(), width: 3.0),
        ),
        child: _getIcon(),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.state) {
      case CheckboxState.checked:
        return AppTheme.primaryGreen;
      case CheckboxState.unchecked:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : AppTheme.white;
      case CheckboxState.empty:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : AppTheme.white.withValues(
                alpha: 0.5,
              ); // More subtle for empty state
    }
  }

  Color _getBorderColor() {
    switch (widget.state) {
      case CheckboxState.checked:
        return AppTheme.primaryGreen;
      case CheckboxState.unchecked:
        return Theme.of(context).brightness == Brightness.dark
            ? AppTheme.mediumGray
            : AppTheme.mediumGray;
      case CheckboxState.empty:
        return Theme.of(context).brightness == Brightness.dark
            ? AppTheme.mediumGray.withValues(alpha: 0.5)
            : AppTheme.mediumGray.withValues(
                alpha: 0.5,
              ); // More subtle for empty state
    }
  }

  Widget? _getIcon() {
    switch (widget.state) {
      case CheckboxState.checked:
        return Icon(
          Icons.check,
          size: widget.size * 0.7,
          color: AppTheme.white,
        );
      case CheckboxState.unchecked:
      case CheckboxState.empty:
        return null;
    }
  }
}
