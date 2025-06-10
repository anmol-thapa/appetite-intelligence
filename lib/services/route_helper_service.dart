import 'package:appetite_intelligence/data/notifers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// -- Custom Page Function --
Page noTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (_, _, _, child) => child,
  );
}

void route(BuildContext context, String destination, int destinationIndex) {
  if (destinationIndex != selectedPageNotifer.value) {
    selectedPageNotifer.value = destinationIndex;
    context.go(destination);
  }
}
