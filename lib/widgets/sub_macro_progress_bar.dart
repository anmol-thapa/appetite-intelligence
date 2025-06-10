import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/services/food_service.dart';
import 'package:appetite_intelligence/widgets/reusables/horizontal_macro_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubMacroProgressBar extends ConsumerWidget {
  const SubMacroProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summarySnapProvider).valueOrNull;

    if (summary == null) {
      return Container();
    }

    int fatsAllowed = summary.macroAllowed['fats']!;
    int carbsAllowed = summary.macroAllowed['carbs']!;
    int proteinAllowed = summary.macroAllowed['protein']!;
    int fatsConsumed = summary.macroCount['fats']!;
    int carbsConsumed = summary.macroCount['carbs']!;
    int proteinConsumed = summary.macroCount['protein']!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        HorizontalMacroProgressIndicator(
          macroType: Macros.fats,
          macroConsumed: fatsConsumed,
          macroAllowed: fatsAllowed,
        ),
        HorizontalMacroProgressIndicator(
          macroType: Macros.carbs,
          macroConsumed: carbsConsumed,
          macroAllowed: carbsAllowed,
        ),
        HorizontalMacroProgressIndicator(
          macroType: Macros.protein,
          macroConsumed: proteinConsumed,
          macroAllowed: proteinAllowed,
        ),
      ],
    );
  }
}
