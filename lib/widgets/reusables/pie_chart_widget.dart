import 'package:appetite_intelligence/data/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.radius,
    required this.sections,
  });
  final double radius;
  final List<PieChartSectionData> sections;

  @override
  Widget build(BuildContext context) {
    final sectionsWithRadius =
        sections.map((s) {
          return s.copyWith(radius: radius);
        }).toList();

    return CircleAvatar(
      radius: radius,
      child: PieChart(
        PieChartData(sectionsSpace: 0, sections: sectionsWithRadius),
      ),
    );
  }

  static PieChartSectionData getSection({
    required int amount,
    required int total,
    required Color color,
    String? title,
    String? titleSuffix,
    bool? pluralSupport,
    IconData? badgeIcon,
  }) {
    final double value = amount.toDouble();

    String displayedTitle;
    if (title != null) {
      displayedTitle = title;
    } else if (titleSuffix == '%') {
      double percent = (amount / total) * 100;
      displayedTitle = percent.toStringAsFixed(0);
    } else {
      displayedTitle = '$amount';
    }
    if (titleSuffix != null) displayedTitle += titleSuffix;
    if (pluralSupport == true) {
      displayedTitle += (amount > 1 || amount == 0) ? 's' : '';
    }

    return PieChartSectionData(
      color: color,
      value: value,
      title: displayedTitle,
      titleStyle: TextStyle(fontSize: 14.0, color: Colors.white),
    );
  }

  static List<PieChartSectionData> generateTripleSections({
    required List<int> values,
    required int total,
    required String titleSuffix,
    bool? pluralSupport,
    List<Color>? colors,
  }) {
    colors ??= [
      KColors.proteinColor,
      KColors.neutralColor,
      KColors.primaryNegative,
    ];
    return List.generate(values.length, (i) {
      return PieChartWidget.getSection(
        amount: values[i],
        total: total,
        color: colors![i],
        titleSuffix: titleSuffix,
        pluralSupport: pluralSupport,
      );
    });
  }
}
