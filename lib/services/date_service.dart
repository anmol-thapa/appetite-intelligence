import 'package:appetite_intelligence/services/firebase_user_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ntp/ntp.dart';

class DateService {
  final DateTime currentDateSelection;

  DateService({required this.currentDateSelection});

  DateService increment({required int amount}) {
    return DateService(
      currentDateSelection: currentDateSelection.add(Duration(days: amount)),
    );
  }

  DateService set({required DateTime dateTime}) {
    return DateService(currentDateSelection: dateTime);
  }

  static Future<DateTime?> getNetworkTime() async {
    try {
      return await NTP.now();
    } catch (_) {
      return null;
    }
  }

  static Future<DateTime> getNetworkTimeOrNow() async {
    DateTime? networkTime = await getNetworkTime();
    return networkTime ?? DateTime.now();
  }

  static Future<Duration?> getNetworkDifference(DateTime dateTime) async {
    DateTime now;
    try {
      now = await NTP.now();
      return now.difference(dateTime);
    } catch (_) {
      return null;
    }
  }
}

class DateSelectionNotifier extends StateNotifier<DateService> {
  DateSelectionNotifier()
    : super(DateService(currentDateSelection: DateTime.now()));

  // Allow up to the current day in current date selection
  Future<void> incrementDay() async {
    final networkNow = await DateService.getNetworkTimeOrNow();

    if (Formatter.dateFormat(date: state.currentDateSelection) !=
        Formatter.dateFormat(date: networkNow)) {
      state = state.increment(amount: 1);
    }
  }

  /// Allow up to 6 days back in current date selection
  Future<void> decrementDay() async {
    final networkNow = await DateService.getNetworkTimeOrNow();

    Duration difference = state.currentDateSelection.difference(networkNow);

    if (difference.inDays <= 0 && difference.inDays > -6) {
      state = state.increment(amount: -1);
    }
  }

  void setDateTime(DateTime dateTime) {
    state = state.set(dateTime: dateTime);
  }

  /// Attempts to sync the time.
  /// If there is an error, such as no network connection, it will set the device's time.
  Future<void> sync() async {
    state = state.set(dateTime: await DateService.getNetworkTimeOrNow());
  }

  bool isCheatDay(WidgetRef ref) {
    final user = ref.read(firebaseUser).valueOrNull;

    return user!.cheatMeals.contains(state.currentDateSelection.weekday);
  }
}

final dateSelectionProvider =
    StateNotifierProvider<DateSelectionNotifier, DateService>(
      (ref) => DateSelectionNotifier(),
    );

final networkTimeProvider = FutureProvider<DateTime>((ref) async {
  return await DateService.getNetworkTimeOrNow();
});
