import 'package:flutter/material.dart';
import '../atoms/triple_state_checkbox.dart';
import '../atoms/prayer_time_label.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/prayer_model.dart';

class PrayerRow extends StatelessWidget {
  final String? prayerName;
  final Prayer? prayer;
  final ValueChanged<CheckboxState>? onStateChanged;
  final VoidCallback? onTap;

  const PrayerRow({
    super.key,
    this.prayerName,
    this.prayer,
    this.onStateChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the checkbox state based on the prayer object
    CheckboxState checkboxState;
    if (prayer == null) {
      checkboxState = CheckboxState.empty;
    } else {
      switch (prayer?.isCompleted) {
        case true:
          checkboxState = CheckboxState.checked;
          break;
        case false:
          checkboxState = CheckboxState.unchecked;
          break;
        case null:
          checkboxState = CheckboxState.empty;
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        onTap?.call();
        switch (checkboxState) {
          case CheckboxState.empty:
            onStateChanged?.call(CheckboxState.checked);
            break;
          case CheckboxState.checked:
            onStateChanged?.call(CheckboxState.unchecked);
            break;
          case CheckboxState.unchecked:
            onStateChanged?.call(CheckboxState.empty);
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : AppTheme.lightGray,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrayerTimeLabel(prayerName: prayer?.name ?? prayerName ?? ''),
            TripleStateCheckbox(
              state: checkboxState,
              onChanged: onStateChanged,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
