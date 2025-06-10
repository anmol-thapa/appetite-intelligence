import 'package:intl/intl.dart';

class Formatter {
  /// Returns a dd-MM-yyyy, UTC, and ISO8601 formatted String
  static String dateFormat({
    required DateTime date,
    String format = 'MM-dd-yyyy',
  }) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  /// Returns a valid % for a progress bar.
  /// If limit == 0, `1` will be returned
  static double percentFormat(int value, int limit) {
    if (limit == 0) {
      return 1;
    }
    return (value / limit);
  }

  static String roundToIntString(dynamic value) {
    if (value == null) return "0";
    try {
      return (value as num).round().toString();
    } catch (_) {
      return "0";
    }
  }

  static int roundToInt(num value) {
    if (value is int) return value;

    return value.round().toInt();
  }
}
