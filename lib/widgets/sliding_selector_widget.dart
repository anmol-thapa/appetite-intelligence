import 'package:appetite_intelligence/data/constants.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class SlidingSelectorWidget extends StatelessWidget {
  const SlidingSelectorWidget({
    super.key,
    required this.children,
    required this.notifier,
    this.onClick,
  });
  final Map<int, Widget> children;
  final ValueNotifier<int> notifier;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return CustomSlidingSegmentedControl<int>(
          isStretch: true,
          initialValue: value,
          children: children,
          decoration: BoxDecoration(
            color: KColors.proteinColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),

          thumbDecoration: BoxDecoration(
            color: KColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(75),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 2.0),
              ),
            ],
          ),
          onValueChanged: (value) {
            notifier.value = value;
            if (onClick != null) {
              onClick!();
            }
          },
        );
      },
    );
  }
}

class SliderOptionText extends StatelessWidget {
  const SliderOptionText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}
