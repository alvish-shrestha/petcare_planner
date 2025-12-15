import 'package:flutter/material.dart';

class SlideFadeRoute extends PageRouteBuilder {
  final Widget page;

  SlideFadeRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.1),
            end: Offset.zero,
          ).animate(animation);

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      );
}
