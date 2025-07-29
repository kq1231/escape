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

  const TripleStateCheckbox({
    super.key,
    this.state = CheckboxState.empty,
    this.onChanged,
    this.size = 24.0,
  });

  @override
  State<TripleStateCheckbox> createState() => _TripleStateCheckboxState();
}

class _TripleStateCheckboxState extends State<TripleStateCheckbox> {
  void _handleTap() {
    if (widget.onChanged == null) return;

    // Cycle through states based on current state
    switch (widget.state) {
      case CheckboxState.empty:
        widget.onChanged!(CheckboxState.checked);
        break;
      case CheckboxState.checked:
        widget.onChanged!(CheckboxState.unchecked);
        break;
      case CheckboxState.unchecked:
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
        return AppTheme.errorRed; // Red background for unchecked state
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
        return AppTheme.errorRed; // Red border for unchecked state
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
        return Icon(
          Icons.close,
          size: widget.size * 0.7,
          color: AppTheme.white, // White "X" for unchecked state
        );
      case CheckboxState.empty:
        return null;
    }
  }
}
