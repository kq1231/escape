// prayer_times_model.dart
class Timings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
      fajr: json['Fajr']?.toString() ?? '',
      sunrise: json['Sunrise']?.toString() ?? '',
      dhuhr: json['Dhuhr']?.toString() ?? '',
      asr: json['Asr']?.toString() ?? '',
      maghrib: json['Maghrib']?.toString() ?? '',
      isha: json['Isha']?.toString() ?? '',
    );
  }
}

class PrayerTimes {
  final Timings timings;
  final String date;

  PrayerTimes({required this.timings, required this.date});

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    // Handle the nested date structure
    final dateData = json['date'] as Map<String, dynamic>?;
    final readableDate = dateData?['readable']?.toString() ?? '';

    // Handle the timings structure
    final timingsData = json['timings'] as Map<String, dynamic>?;
    final timings = timingsData != null
        ? Timings.fromJson(timingsData)
        : Timings(
            fajr: '',
            sunrise: '',
            dhuhr: '',
            asr: '',
            maghrib: '',
            isha: '',
          );

    return PrayerTimes(timings: timings, date: readableDate);
  }
}
