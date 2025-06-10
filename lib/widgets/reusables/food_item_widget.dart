import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/models/food_model.dart';
import 'package:appetite_intelligence/services/food_service.dart';
import 'package:appetite_intelligence/widgets/reusables/card_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/vertical_macro_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FoodItemWidget extends ConsumerWidget {
  final FoodModel foodModel;
  const FoodItemWidget({super.key, required this.foodModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String name = foodModel.name;
    int baseCalories = foodModel.nitrution['calories']!;
    int baseFats = foodModel.nitrution['fats']!;
    int baseCarbs = foodModel.nitrution['carbs']!;
    int baseProtein = foodModel.nitrution['protein']!;
    num servingSize = foodModel.serving['size'];
    String servingUnit = foodModel.serving['unit'];
    int baseServingSize = foodModel.serving['base'];
    HealthRating healthRating = foodModel.healthRating;

    double adjustedServingSize = servingSize / baseServingSize;
    int adjustedCalories = (baseCalories * adjustedServingSize).toInt();
    int adjustedFats = (baseFats * adjustedServingSize).toInt();
    int adjustedCarbs = (baseCarbs * adjustedServingSize).toInt();
    int adjustedProtein = (baseProtein * adjustedServingSize).toInt();

    IconData healthIcon = Icons.clear;
    Color? color;
    if (healthRating == HealthRating.healthy) {
      healthIcon = Icons.eco;
      color = KColors.primaryColor;
    } else if (healthRating == HealthRating.netural) {
      healthIcon = Icons.horizontal_rule;
      color = KColors.primaryCaution;
    } else if (healthRating == HealthRating.junk) {
      healthIcon = Icons.clear;
      color = KColors.primaryNegative;
    }

    if (servingUnit == 'serving' && servingSize > 1) {
      servingUnit = 'servings';
    }
    int truncatedSize = servingSize.truncate();
    if (truncatedSize == servingSize) {
      servingSize = truncatedSize;
    }

    double fatPercentage;
    double carbsPercentage;
    double proteinPercentage;

    if (adjustedFats == 0 || adjustedCalories == 0) {
      fatPercentage = 0;
    } else {
      fatPercentage = 9 * adjustedFats / adjustedCalories;
    }
    if (adjustedCarbs == 0 || adjustedCalories == 0) {
      carbsPercentage = 0;
    } else {
      carbsPercentage = 4 * adjustedCarbs / adjustedCalories;
    }
    if (adjustedProtein == 0 || adjustedCalories == 0) {
      proteinPercentage = 0;
    } else {
      proteinPercentage = 4 * adjustedProtein / adjustedCalories;
    }

    return CardWidget(
      child: Column(
        children: [
          Row(
            children: [
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: healthRating.name,
                child: Icon(healthIcon, color: color),
              ),

              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 225),
                    child: Text(name, style: KFoodItemCardStyle.foodName),
                  ),
                  Row(
                    children: [
                      Text(
                        "$adjustedCalories calories | $servingSize $servingUnit",
                        style: KFoodItemCardStyle.foodInfo,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder:
                        (context) => CupertinoAlertDialog(
                          title: Text("Delete food?"),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                FoodService.deleteFood(ref, foodModel);
                                context.pop();
                              },
                              child: Text("Yes"),
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () => context.pop(),
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                  );
                },
                icon: Icon(Icons.more_horiz),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalMacroProgressIndicator(
                macroType: Macros.fats,
                percentage: fatPercentage,
                macroAmount: adjustedFats,
                vertical: true,
              ),
              VerticalMacroProgressIndicator(
                macroType: Macros.carbs,
                percentage: carbsPercentage,
                macroAmount: adjustedCarbs,
                vertical: true,
              ),
              VerticalMacroProgressIndicator(
                macroType: Macros.protein,
                percentage: proteinPercentage,
                macroAmount: adjustedProtein,
                vertical: true,
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
