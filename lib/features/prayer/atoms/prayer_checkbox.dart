import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

enum CheckboxState {
  checked,   // Prayer completed
  unchecked, // Prayer not completed
  empty,     // Prayer not recorded/deleted
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
        // Only show container for unchecked or empty
        decoration: widget.state == CheckboxState.checked
            ? null
            : BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                border: Border.all(
                  color: _getBorderColor(),
                  width: 3.0,
                ),
              ),
        child: _getIcon(),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.state) {
      case CheckboxState.checked:
        return Colors.transparent; // not used
      case CheckboxState.unchecked:
        return AppConstants.errorRed;
      case CheckboxState.empty:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : AppConstants.white.withOpacity(0.5);
    }
  }

  Color _getBorderColor() {
    switch (widget.state) {
      case CheckboxState.checked:
        return Colors.transparent; // no border for checked
      case CheckboxState.unchecked:
        return AppConstants.errorRed;
      case CheckboxState.empty:
        return Theme.of(context).brightness == Brightness.dark
            ? AppConstants.mediumGray.withOpacity(0.5)
            : AppConstants.mediumGray.withOpacity(0.5);
    }
  }

  Widget? _getIcon() {
    switch (widget.state) {
      case CheckboxState.checked:
        return Center(
          child: Image.asset(
            'assets/checked.png',
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
      case CheckboxState.unchecked:
        return Icon(
          Icons.close,
          size: widget.size * 0.7,
          color: AppConstants.white,
        );
      case CheckboxState.empty:
        return null;
    }
  }
}
