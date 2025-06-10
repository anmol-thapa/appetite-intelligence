import 'package:appetite_intelligence/util/formatter.dart';
import 'package:flutter/material.dart';
import 'package:appetite_intelligence/data/constants.dart';

class HorizontalMacroProgressIndicator extends StatelessWidget {
  const HorizontalMacroProgressIndicator({
    super.key,
    required this.macroType,
    required this.macroConsumed,
    required this.macroAllowed,
  });
  final Macros macroType;
  final int macroConsumed;
  final int macroAllowed;

  @override
  Widget build(BuildContext context) {
    double percentage = Formatter.percentFormat(macroConsumed, macroAllowed);
    Color macroColor;
    String macroName;
    Color? textColor;

    if (percentage > 1.25) {
      textColor = KColors.primaryNegative;
    } else if (percentage > 1.15) {
      textColor = KColors.primaryCaution;
    }

    switch (macroType) {
      case Macros.fats:
        macroColor = KColors.fatsColor;
        macroName = "Fats";
        break;
      case Macros.carbs:
        macroColor = KColors.carbsColor;
        macroName = "Carbs";
        break;
      case Macros.protein:
        macroColor = KColors.proteinColor;
        macroName = "Protein";
        break;
    }

    return Column(
      children: [
        Text(macroName, style: KFoodItemCardStyle.horizontallMacroName),
        SizedBox(
          width: 75,
          child: TweenAnimationBuilder(
            duration: KAnimation.progressFillDuration,
            tween: Tween<double>(begin: 0, end: percentage),
            curve: KAnimation.progressFillCurve,
            builder:
                (context, value, _) => LinearProgressIndicator(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  minHeight: 8,
                  value: value,
                  color: macroColor,
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$macroConsumed"
              "g",
              style: KFoodItemCardStyle.macroAmount.copyWith(color: textColor),
            ),
            Text(
              "/$macroAllowed"
              "g",
            ),
          ],
        ),
      ],
    );
  }
}
