import 'dart:async';
import 'package:flutter/material.dart';

class NextPrayerCard extends StatefulWidget {
  final Map<String, String> todayPrayerTimes; 

  const NextPrayerCard({
    super.key,
    required this.todayPrayerTimes,
  });

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  late String nextPrayerName;
  late DateTime nextPrayerTime;
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _computeNextPrayer();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remaining = nextPrayerTime.difference(DateTime.now());
        if (remaining.isNegative) {
          _computeNextPrayer(); // Update to the next prayer when current passes
        }
      });
    });
  }

  void _computeNextPrayer() {
    final now = DateTime.now();
    for (var entry in widget.todayPrayerTimes.entries) {
      final parts = entry.value.split(':');
      DateTime prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (prayerDateTime.isAfter(now)) {
        nextPrayerName = entry.key;
        nextPrayerTime = prayerDateTime;
        remaining = prayerDateTime.difference(now);
        return;
      }
    }

    // If all today's prayers passed, fallback to Fajr of tomorrow
    final fajrParts = widget.todayPrayerTimes['Fajr']!.split(':');
    nextPrayerName = 'Fajr';
    nextPrayerTime = DateTime(
      now.year,
      now.month,
      now.day + 1,
      int.parse(fajrParts[0]),
      int.parse(fajrParts[1]),
    );
    remaining = nextPrayerTime.difference(now);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage("assets/islamic_bg.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "NEXT PRAYER",
            style: TextStyle(
              color: Colors.amber.shade200,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            nextPrayerName,
            style: const TextStyle(
              fontSize: 34,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timerBox(hours),
              _separator(),
              _timerBox(minutes),
              _separator(),
              _timerBox(seconds),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerBox(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.white10, blurRadius: 8)],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _separator() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          ":",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
