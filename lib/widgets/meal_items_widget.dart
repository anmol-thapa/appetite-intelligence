import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/services/food_service.dart';
import 'package:appetite_intelligence/widgets/reusables/food_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealItemsWidget extends ConsumerWidget {
  const MealItemsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mealsProvider).valueOrNull;

    if (items == null) {
      return Container();
    }

    return ValueListenableBuilder<int>(
      valueListenable: selectedMealTimeNotifier,
      builder: (context, value, child) {
        return Column(
          children: [
            ...List.generate(items.length, (index) {
              if (items[index].mealTime.index == value) {
                return FoodItemWidget(foodModel: items[index]);
              }
              return Container();
            }),
          ],
        );
      },
    );
  }
}
