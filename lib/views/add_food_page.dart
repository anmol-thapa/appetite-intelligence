import 'package:appetite_intelligence/models/food_model.dart';
import 'package:appetite_intelligence/models/scanned_food_mode.dart';
import 'package:appetite_intelligence/services/food_service.dart';
import 'package:appetite_intelligence/services/ui_service.dart';
import 'package:appetite_intelligence/util/text_util.dart';
import 'package:appetite_intelligence/widgets/reusables/card_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/drop_down_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/food_data_text_field_widget.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFoodPage extends ConsumerStatefulWidget {
  const AddFoodPage({super.key, required this.mealTimeName});
  final String mealTimeName;

  @override
  ConsumerState<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends ConsumerState<AddFoodPage> {
  @override
  void dispose() {
    nameController.dispose();
    caloriesController.dispose();
    fatsController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController servingSizeController = TextEditingController();
  final TextEditingController servingSizeUnitController = TextEditingController(
    text: 'serving',
  );
  int baseServingSize = 1;
  double servingsTextFieldWidth = TextUtil.recalculateTextWidth('serving');
  HealthRating? selectedRating;

  Future<void> barcodeScan() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      String content = result.rawContent;
      var response = await http.get(
        Uri.parse(
          "https://world.openfoodfacts.net/api/v2/product/$content.json",
        ),
      );
      var decoded = jsonDecode(response.body) as Map<String, dynamic>;
      ScannedFoodModel? scannedFoodModel = ScannedFoodModel.parseFromData(
        decoded,
      );
      fillFields(scannedFoodModel, 175);
    } else if (mounted && result.type == ResultType.Error) {
      showPopup(context, "There was an error");
    }
  }

  Future<void> fillFields(
    ScannedFoodModel? scannedFoodModel,
    int msDelay,
  ) async {
    if (scannedFoodModel == null) {
      showPopup(context, "Unable to scan product");
      return;
    }

    nameController.text = scannedFoodModel.name;
    await Future.delayed(Duration(milliseconds: msDelay));

    caloriesController.text = scannedFoodModel.calories.toString();
    await Future.delayed(Duration(milliseconds: msDelay));

    servingSizeController.text = scannedFoodModel.servingSize.toString();
    baseServingSize = scannedFoodModel.baseServingSize;
    servingSizeUnitController.text = scannedFoodModel.servingUnit.toString();
    setState(() {
      servingsTextFieldWidth = TextUtil.recalculateTextWidth(
        servingSizeUnitController.text,
      );
    });
    await Future.delayed(Duration(milliseconds: msDelay));

    fatsController.text = scannedFoodModel.fats.toString();
    await Future.delayed(Duration(milliseconds: msDelay));

    carbsController.text = scannedFoodModel.carbs.toString();
    await Future.delayed(Duration(milliseconds: msDelay));

    proteinController.text = scannedFoodModel.protein.toString();
    await Future.delayed(Duration(milliseconds: msDelay));

    HealthRating? predictedHealthRating =
        scannedFoodModel.predictedHealthRating;
    setState(() {
      selectedRating = predictedHealthRating;
    });
  }

  void addFood(WidgetRef ref) {
    if (nameController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        fatsController.text.isEmpty ||
        carbsController.text.isEmpty ||
        proteinController.text.isEmpty ||
        selectedRating == null) {
      showPopup(context, "Please fill all items!");
      return;
    }

    double? servingSize = double.tryParse(servingSizeController.text);
    if (servingSize == null || servingSize <= 0) {
      showPopup(context, "Invalid servings size.");
      return;
    }

    String name = nameController.text.trim();
    int calories = int.parse(caloriesController.text);
    int fats = int.parse(fatsController.text);
    int carbs = int.parse(carbsController.text);
    int protein = int.parse(proteinController.text);
    String servingUnit = servingSizeUnitController.text.trim();

    int macroKcal = 9 * fats + 4 * (carbs + protein);

    if (calories * (servingSize / baseServingSize) > 2500) {
      showPopup(context, "Max calories for an item is 2500kcal!");
      return;
    }

    if (macroKcal > calories * 1.25 || macroKcal < calories * .75) {
      showPopup(
        context,
        "Please check your input. The food calories is ${calories}kcal, but the calories from macros is ${macroKcal}kcal",
      );
      return;
    }

    final foodModel = FoodModel.create(
      name: name,
      nitrution: {
        'calories': calories,
        'fats': fats,
        'carbs': carbs,
        'protein': protein,
      },
      mealTime: MealTime.values.byName(widget.mealTimeName),
      healthRating: selectedRating!,
      serving: {
        'size': servingSize,
        'unit': servingUnit,
        'base': baseServingSize,
      },
    );

    FoodService.addFood(ref, foodModel);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Calories
          CardWidget(
            child: Column(
              spacing: 16,
              children: [
                FoodDataTextFieldWidget(
                  name: "Name",
                  controller: nameController,
                  maxLength: 30,
                ),
                FoodDataTextFieldWidget(
                  name: "Calories",
                  controller: caloriesController,
                  maxLength: 4,
                  numbersOnly: true,
                  endUnit: "kcal",
                ),
                SizedBox(
                  width: double.infinity,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: FoodDataTextFieldWidget(
                          name: "Serving Size",
                          controller: servingSizeController,
                          maxLength: 3,
                          numbersOnly: true,
                          decimals: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: servingsTextFieldWidth + 10,
                        child: TextField(
                          controller: servingSizeUnitController,
                          enabled: false,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Macros + Rating Section
          CardWidget(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Macros
                  Column(
                    children: [
                      SizedBox(
                        width: 110,
                        child: FoodDataTextFieldWidget(
                          name: "Fats",
                          controller: fatsController,
                          maxLength: 3,
                          numbersOnly: true,
                          endUnit: "g",
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 110,
                        child: FoodDataTextFieldWidget(
                          name: "Carbs",
                          controller: carbsController,
                          maxLength: 3,
                          numbersOnly: true,
                          endUnit: "g",
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 110,
                        child: FoodDataTextFieldWidget(
                          name: "Protein",
                          controller: proteinController,
                          maxLength: 3,
                          numbersOnly: true,
                          endUnit: "g",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Tooltip(
                              triggerMode: TooltipTriggerMode.tap,
                              message:
                                  "Barcode food ratings might not be accurate.",
                              child: Icon(Icons.info, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropDownWidget<HealthRating>(
                          label: 'Health Rating',
                          value: selectedRating,
                          hint: 'Select rating...',
                          width:
                              200, // Optional: adjust or remove for full width
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedRating = value);
                            }
                          },
                          items:
                              HealthRating.values.map((rating) {
                                final label =
                                    rating.name[0].toUpperCase() +
                                    rating.name.substring(1);
                                return DropdownMenuItem(
                                  value: rating,
                                  child: Text(
                                    label,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Barcode"),
                  onPressed: barcodeScan,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Food"),
                  onPressed: () => addFood(ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
