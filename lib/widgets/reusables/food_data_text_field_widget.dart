import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodDataTextFieldWidget extends StatelessWidget {
  const FoodDataTextFieldWidget({
    super.key,
    required this.name,
    required this.controller,
    required this.maxLength,
    this.numbersOnly = false,
    this.decimals = false,
    this.endUnit,
  });

  final String name;
  final TextEditingController controller;
  final int maxLength;
  final bool numbersOnly;
  final bool decimals;
  final String? endUnit;

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? formatters;

    if (decimals) {
      formatters = [
        FilteringTextInputFormatter.allow(
          RegExp(decimals ? r'^\d*\.?\d*' : r'\d+'),
        ),
      ];
    } else if (numbersOnly) {
      formatters = [FilteringTextInputFormatter.digitsOnly];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  buildCounter:
                      (
                        _, {
                        required currentLength,
                        required isFocused,
                        required maxLength,
                      }) => null,
                  maxLength: maxLength,
                  keyboardType:
                      numbersOnly
                          ? TextInputType.numberWithOptions(decimal: decimals)
                          : null,
                  inputFormatters: formatters,
                ),
              ),
              if (endUnit != null) ...[
                const SizedBox(width: 10),
                Text(endUnit!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
