import 'package:appetite_intelligence/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.name,
    required this.controller,
    required this.maxLength,
    this.numbersOnly = false,
    this.enabled = true,
  });

  final String name;
  final TextEditingController controller;
  final int maxLength;
  final bool numbersOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? formatters;

    if (numbersOnly) {
      formatters = [FilteringTextInputFormatter.digitsOnly];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: KPageSettings.semiBold),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  enabled: enabled,
                  controller: controller,
                  buildCounter:
                      (
                        _, {
                        required currentLength,
                        required isFocused,
                        required maxLength,
                      }) => null,
                  maxLength: maxLength != -1 ? maxLength : null,
                  keyboardType: numbersOnly ? TextInputType.number : null,
                  inputFormatters: formatters,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
