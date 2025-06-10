import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/services/firebase_user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBarWidget extends ConsumerWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUser).valueOrNull;
    final name = user?.name.split(' ')[0] ?? 'Loading';

    return Row(
      children: [
        CircleAvatar(radius: 35),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ", style: KHomePageStyle.titleWelcomeText),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(name, style: KHomePageStyle.titleNameText),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.push("/settings"),
          icon: KHomePageStyle.settingsIcon,
        ),
      ],
    );
  }
}
