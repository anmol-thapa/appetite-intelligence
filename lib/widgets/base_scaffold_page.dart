import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/data/notifers.dart';
import 'package:flutter/material.dart';

class BaseScaffoldPage extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool? showAppBar;
  final bool? scroll;

  const BaseScaffoldPage({
    super.key,
    required this.child,
    this.appBar,
    this.showAppBar,
    this.scroll,
  });

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? effectiveAppBar;
    if (showAppBar == null) {
      effectiveAppBar = appBar;
    } else if (showAppBar == true) {
      effectiveAppBar = AppBar();
    } else {
      effectiveAppBar = null;
    }

    final scaffold = Scaffold(
      appBar: effectiveAppBar,
      body: Padding(
        padding: KPageSettings.pagePadding,
        child: scroll == true ? SingleChildScrollView(child: child) : child,
      ),
    );

    return ValueListenableBuilder<bool>(
      valueListenable: isLoadingNotifier,
      builder: (context, loading, _) {
        return Stack(
          children: [
            scaffold,
            if (loading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(127),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: KColors.primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
