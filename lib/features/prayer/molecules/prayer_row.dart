import 'package:flutter/material.dart';
import '../../../models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';
import 'package:escape/widgets/xp_badge.dart';
import 'package:escape/theme/app_constants.dart';

class PrayerRow extends StatefulWidget {
  final String prayerName;
  final String? time;
  final Prayer? prayer;
  final int xp;
  final Function(CheckboxState)? onStateChanged;
  final VoidCallback? onTap;

  const PrayerRow({
    super.key,
    required this.prayerName,
    this.time,
    required this.prayer,
    required this.xp,
    this.onStateChanged,
    this.onTap,
  });

  @override
  State<PrayerRow> createState() => _PrayerRowState();
}

class _PrayerRowState extends State<PrayerRow>
    with SingleTickerProviderStateMixin {
  static const Color mainGreen = Color.fromARGB(255, 30, 106, 58);
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final bool isTahajjud = widget.prayerName == "Tahajjud";
    final bool isCompleted = widget.prayer?.isCompleted == true;

    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.97),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: mainGreen,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Circle avatar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getPrayerColor(widget.prayerName),
                ),
                child: Icon(
                  _getIconForPrayer(widget.prayerName),
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prayerName,
                          style: const TextStyle(
                            color: mainGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Exo',
                          ),
                        ),
                        if (!isTahajjud && widget.time != null)
                          Text(
                            widget.time!,
                            style: const TextStyle(
                              color: mainGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Show XP badge if prayer is completed
                    if (isCompleted)
                      XPBadge(
                        xpAmount: widget.xp,
                        backgroundColor: AppConstants.primaryGreen,
                        fontSize: 14,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              TripleStateCheckbox(
                state: widget.prayer == null
                    ? CheckboxState.empty
                    : (widget.prayer!.isCompleted
                        ? CheckboxState.checked
                        : CheckboxState.unchecked),
                onChanged: widget.onStateChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPrayerColor(String name) {
    switch (name) {
      case "Fajr":
        return const Color(0xFF6B5CE5);
      case "Dhuhr":
        return const Color(0xFFFFC107);
      case "Asr":
        return const Color(0xFFFF9800);
      case "Maghrib":
        return const Color(0xFFF44336);
      case "Isha":
        return const Color(0xFF7B1FA2);
      case "Tahajjud":
        return const Color(0xFF4A148C);
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForPrayer(String prayerName) {
    switch (prayerName) {
      case "Fajr":
        return Icons.wb_twighlight;
      case "Dhuhr":
        return Icons.wb_sunny;
      case "Asr":
        return Icons.sunny_snowing;
      case "Maghrib":
        return Icons.sunny_snowing;
      case "Isha":
        return Icons.nightlight;
      case "Tahajjud":
        return Icons.brightness_3;
      default:
        return Icons.access_time;
    }
  }
}
