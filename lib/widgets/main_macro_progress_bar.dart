import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/services/food_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainMacroProgressBar extends ConsumerWidget {
  const MainMacroProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summarySnapProvider).valueOrNull;

    if (summary == null) {
      return Container();
    }

    int caloriesConsumed = summary.caloriesConsumed;
    int caloriesAllowed = summary.caloriesAllowed;
    double mainBarFill =
        Formatter.percentFormat(caloriesConsumed, caloriesAllowed) * 100;

    Color textColor;
    if (mainBarFill > 107) {
      textColor = KColors.primaryNegative;
    } else if (mainBarFill > 102) {
      textColor = KColors.primaryCaution;
    } else {
      textColor = KColors.primaryColor;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ArcProgressBar(
          animationDuration: KAnimation.progressFillDuration,
          animationCurve: KAnimation.progressFillCurve,
          percentage: mainBarFill,
          arcThickness: 30,
          innerPadding: 50,
          strokeCap: StrokeCap.round,
          handleSize: 0,
          foregroundColor: textColor,
          backgroundColor: KColors.primaryColor.withAlpha(100),
        ),
        Positioned(
          bottom: 30,
          child: Column(
            children: [
              Text(
                "$caloriesConsumed",
                style: KMainProgressBarStyle.mainCalories.copyWith(
                  color: textColor,
                ),
              ),
              Text(
                "out of $caloriesAllowed calories",
                style: KMainProgressBarStyle.outOfCalories,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
