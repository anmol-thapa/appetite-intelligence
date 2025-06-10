import 'package:appetite_intelligence/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> logout() async {
    await AuthService().logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(onPressed: logout, child: const Text('Logout')),
    );
  }
}
