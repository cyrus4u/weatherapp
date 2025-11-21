import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ✅ Option 1: Simple function (recommended for most cases)
// String formatUnixTime(int timestamp) {
//   final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
//   final localTime = dateTime.toLocal();
//   final hour = localTime.hour > 12 ? localTime.hour - 12 : (localTime.hour == 0 ? 12 : localTime.hour);
//   final period = localTime.hour >= 12 ? 'PM' : 'AM';
//   return '$hour:${localTime.minute.toString().padLeft(2, '0')} $period';
// }
// Usage:

// final sunriseText = formatUnixTime(weatherData['sys']['sunrise']);
// final sunsetText = formatUnixTime(weatherData['sys']['sunset']);

// 🌇 Option 2: As a Flutter Widget

// Useful if you want to show it directly in UI without calling the function separately.

// class UnixTimeText extends StatelessWidget {
//   final int timestamp;
//   const UnixTimeText({super.key, required this.timestamp});

//   @override
//   Widget build(BuildContext context) {
//     final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true).toLocal();
//     final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
//     final period = dateTime.hour >= 12 ? 'PM' : 'AM';
//     final formatted = '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';

//     return Text(formatted, style: const TextStyle(fontSize: 16, color: Colors.white));
//   }
// }
// Usage:

// UnixTimeText(timestamp: weatherData['sys']['sunset']),

// ⚙️ Option 3: As a Dart Extension

// Cleaner and reusable in any part of your app.
// extension UnixTimeFormatter on int {
//   String toFormattedTime() {
//     final dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000, isUtc: true).toLocal();
//     final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
//     final period = dateTime.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
//   }
// }
// Usage:

// print(weatherData['sys']['sunrise'].toFormattedTime()); // "6:43 AM"

// Would you like me to modify this so it automatically adjusts to the city’s timezone (using the API’s timezone field)?
// That makes it 100% accurate to the local sunrise/sunset time of that city.

// ✅ Step-by-step Solution using intl
// 🕓 2. Convert and format the UNIX timestamp

// Here’s a clean, reusable function using intl:

// String formatUnixTimeWithIntl(int timestamp, {int? timezoneOffsetInSeconds}) {
//   // Convert from seconds to milliseconds
//   DateTime utcTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);

//   // Adjust for city timezone if provided (OpenWeather returns "timezone" offset in seconds)
//   if (timezoneOffsetInSeconds != null) {
//     utcTime = utcTime.add(Duration(seconds: timezoneOffsetInSeconds));
//   }

//   // Format: 10:15 AM / 8:05 PM
//   return DateFormat('h:mm a').format(utcTime);
// }
// 🧠 3. Example usage (with OpenWeather API data)
// final sunrise = weatherData['sys']['sunrise'];
// final sunset = weatherData['sys']['sunset'];
// final timezoneOffset = weatherData['timezone']; // e.g. 16200 for +4:30

// final sunriseTime = formatUnixTimeWithIntl(sunrise, timezoneOffsetInSeconds: timezoneOffset);
// final sunsetTime  = formatUnixTimeWithIntl(sunset, timezoneOffsetInSeconds: timezoneOffset);

// print('Sunrise: $sunriseTime');
// print('Sunset:  $sunsetTime');
// Output example:
// Sunrise: 6:43 AM
// Sunset:  6:19 PM

// 💡 Optional — Extension version (cleaner code)

// If you prefer writing timestamp.toLocalTime(), use this:
extension UnixTimeIntl on int {
  String toFormattedTime(int? timezoneOffsetInSeconds) {
    DateTime utcTime = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );
    if (timezoneOffsetInSeconds != null) {
      utcTime = utcTime.add(Duration(seconds: timezoneOffsetInSeconds));
    }
    return DateFormat('h:mm a').format(utcTime);
  }
}

// print(weatherData['sys']['sunrise'].toFormattedTime(timezoneOffsetInSeconds: weatherData['timezone']));
