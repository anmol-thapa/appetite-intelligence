import 'package:appetite_intelligence/data/constants.dart';
import 'package:flutter/material.dart';

class VerticalMacroProgressIndicator extends StatelessWidget {
  const VerticalMacroProgressIndicator({
    super.key,
    required this.macroType,
    required this.percentage,
    required this.macroAmount,
    this.vertical,
  });
  final Macros macroType;
  final double percentage;
  final bool? vertical;
  final int macroAmount;

  @override
  Widget build(BuildContext context) {
    Color macroColor;
    String macroName;

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

    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            width: 50,
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
        ),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$macroAmount"
              "g",
              style: KFoodItemCardStyle.macroAmount,
            ),
            Text(macroName, style: KFoodItemCardStyle.verticalMacroName),
          ],
        ),
      ],
    );
  }
}
