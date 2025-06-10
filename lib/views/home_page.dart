import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/widgets/date_selector_widget.dart';
import 'package:appetite_intelligence/widgets/main_macro_progress_bar.dart';
import 'package:appetite_intelligence/widgets/meal_items_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/card_widget.dart';
import 'package:appetite_intelligence/widgets/sliding_selector_widget.dart';
import 'package:appetite_intelligence/widgets/sub_macro_progress_bar.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardWidget(
          child: Column(
            children: [
              DateSelectorWidget(),
              MainMacroProgressBar(),
              SizedBox(height: 30),
              SubMacroProgressBar(),
            ],
          ),
        ),
        SizedBox(height: 30),
        Column(
          spacing: 15,
          children: [
            SlidingSelectorWidget(
              children: {
                0: SliderOptionText(text: "Breakfast"),
                1: SliderOptionText(text: "Lunch"),
                2: SliderOptionText(text: "Dinner"),
              },
              notifier: selectedMealTimeNotifier,
            ),
            MealItemsWidget(),
          ],
        ),
      ],
    );
  }
}
