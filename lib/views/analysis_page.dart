import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/services/database_service.dart';
import 'package:appetite_intelligence/services/ui_service.dart';
import 'package:appetite_intelligence/widgets/reusables/card_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/pie_chart_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/primary_button_widget.dart';
import 'package:appetite_intelligence/widgets/sliding_selector_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  bool isLoading = true;

  int healthyMealCount = 0;
  int neutralMealCount = 0;
  int junkMealCount = 0;
  int totalMealCount = 0;

  List<PieChartSectionData> healthSectionData = [];
  List<PieChartSectionData> fatsSectionData = [];
  List<PieChartSectionData> carbsSectionData = [];
  List<PieChartSectionData> proteinSectionData = [];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final selectedValue = selectedMealAnalysisNotifier.value;
    setState(() => isLoading = true);

    final duration =
        [
          Duration(days: 0),
          Duration(days: 7),
          Duration(days: 30),
        ][selectedValue];
    final docs = await DatabaseService.getMealDocsWithin(duration);

    if (docs.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    int healthyCount = 0, neutralCount = 0, junkCount = 0;
    int fatHealthy = 0, fatNeutral = 0, fatJunk = 0;
    int carbHealthy = 0, carbNeutral = 0, carbJunk = 0;
    int proteinHealthy = 0, proteinNeutral = 0, proteinJunk = 0;

    for (final doc in docs) {
      final ratingCounts = doc['mealRatingCount'] ?? {};
      healthyCount += (ratingCounts['healthy'] ?? 0) as int;
      neutralCount += (ratingCounts['netural'] ?? 0) as int;
      junkCount += (ratingCounts['junk'] ?? 0) as int;

      final macroRatings = doc['mealRatingMacroCount'] ?? {};
      final healthyMacros = macroRatings['healthy'] ?? {};
      final neutralMacros = macroRatings['netural'] ?? {};
      final junkMacros = macroRatings['junk'] ?? {};

      fatHealthy += (healthyMacros['fats'] ?? 0) as int;
      carbHealthy += (healthyMacros['carbs'] ?? 0) as int;
      proteinHealthy += (healthyMacros['protein'] ?? 0) as int;

      fatNeutral += (neutralMacros['fats'] ?? 0) as int;
      carbNeutral += (neutralMacros['carbs'] ?? 0) as int;
      proteinNeutral += (neutralMacros['protein'] ?? 0) as int;

      fatJunk += (junkMacros['fats'] ?? 0) as int;
      carbJunk += (junkMacros['carbs'] ?? 0) as int;
      proteinJunk += (junkMacros['protein'] ?? 0) as int;
    }

    if (!mounted) {
      return;
    }

    final totalMeals = healthyCount + neutralCount + junkCount;
    final totalFats = fatHealthy + fatNeutral + fatJunk;
    final totalCarbs = carbHealthy + carbNeutral + carbJunk;
    final totalProteins = proteinHealthy + proteinNeutral + proteinJunk;

    setState(() {
      healthyMealCount = healthyCount;
      neutralMealCount = neutralCount;
      junkMealCount = junkCount;
      totalMealCount = totalMeals;

      healthSectionData = PieChartWidget.generateTripleSections(
        values: [healthyCount, neutralCount, junkCount],
        total: totalMeals,
        titleSuffix: ' item',
        pluralSupport: true,
      );

      fatsSectionData = PieChartWidget.generateTripleSections(
        values: [fatHealthy, fatNeutral, fatJunk],
        total: totalFats,
        titleSuffix: '%',
      );

      carbsSectionData = PieChartWidget.generateTripleSections(
        values: [carbHealthy, carbNeutral, carbJunk],
        total: totalCarbs,
        titleSuffix: '%',
      );

      proteinSectionData = PieChartWidget.generateTripleSections(
        values: [proteinHealthy, proteinNeutral, proteinJunk],
        total: totalProteins,
        titleSuffix: '%',
      );

      selectedMealAnalysisNotifier.value = selectedValue;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardWidget(
            child: Column(
              children: [
                SlidingSelectorWidget(
                  children: const {
                    0: SliderOptionText(text: 'Daily'),
                    1: SliderOptionText(text: 'Weekly'),
                    2: SliderOptionText(text: 'Monthly'),
                  },
                  notifier: selectedMealAnalysisNotifier,
                  onClick: () => !isLoading ? _loadMeals() : null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Meal Ratings Breakdown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      isLoading
                          ? CircularProgressIndicator(
                            color: KColors.primaryColor,
                          )
                          : PieChartWidget(
                            radius: 75,
                            sections: healthSectionData,
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMacroPieChart(
                      label: 'Fats',
                      isLoading: isLoading,
                      sections: fatsSectionData,
                    ),
                    _buildMacroPieChart(
                      label: 'Carbs',
                      isLoading: isLoading,
                      sections: carbsSectionData,
                    ),
                    _buildMacroPieChart(
                      label: 'Protein',
                      isLoading: isLoading,
                      sections: proteinSectionData,
                    ),
                  ],
                ),
                SizedBox(height: 25),
                _LegendRow(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            onClick: () => showPopup(context, 'Coming Soon!'),
            text: 'Analyze with AI',
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPieChart({
    required String label,
    required bool isLoading,
    required List<PieChartSectionData> sections,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        isLoading
            ? CircularProgressIndicator(color: KColors.primaryColor)
            : PieChartWidget(radius: 45, sections: sections),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  static Row _legendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(color: KColors.primaryColor, label: 'Healthy'),
        SizedBox(width: 8),
        _legendItem(color: KColors.neturalColor, label: 'Neutral'),
        SizedBox(width: 8),
        _legendItem(color: KColors.primaryNegative, label: 'Junk'),
      ],
    );
  }
}
