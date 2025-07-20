import 'package:appetite_intelligence/services/date_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateSelectorWidget extends ConsumerWidget {
  const DateSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateNotifier = ref.watch(dateSelectionProvider);
    final networkTime = ref.watch(networkTimeProvider);

    final DateTime selectedDate = dateNotifier.currentDateSelection;

    final netTime = networkTime.valueOrNull;
    final isToday =
        netTime != null &&
        selectedDate.year == netTime.year &&
        selectedDate.month == netTime.month &&
        selectedDate.day == netTime.day;

    final isCheatDay = ref
        .watch(dateSelectionProvider.notifier)
        .isCheatDay(ref);
    final daysBehind =
        netTime != null ? netTime.difference(selectedDate).inDays : 0;

    final isAtEarliestLimit = daysBehind >= 5;

    String displayedDate =
        isToday ? 'Today' : Formatter.dateFormat(date: selectedDate);
    displayedDate += isCheatDay ? ' - Cheat Day!' : '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed:
              isAtEarliestLimit
                  ? null
                  : () =>
                      ref.read(dateSelectionProvider.notifier).decrementDay(),
          icon: Icon(
            Icons.arrow_back,
            color: isAtEarliestLimit ? Colors.grey : null,
          ),
        ),
        Text(displayedDate),
        IconButton(
          onPressed:
              isToday
                  ? null
                  : () =>
                      ref.read(dateSelectionProvider.notifier).incrementDay(),
          icon: Icon(Icons.arrow_forward, color: isToday ? Colors.grey : null),
        ),
      ],
    );
  }
}
