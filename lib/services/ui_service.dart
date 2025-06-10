import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showPopup(
  BuildContext context,
  String message, {
  String actionButtonText = 'Okay',
}) {
  showAdaptiveDialog(
    context: context,
    builder:
        (context) => AlertDialog.adaptive(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(actionButtonText),
            ),
          ],
        ),
  );
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
