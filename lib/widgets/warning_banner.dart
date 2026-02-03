import 'package:flutter/material.dart';

class WarningBanner extends StatelessWidget {
  final bool visible;
  const WarningBanner({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: double.infinity,
          color: Colors.red.withValues(alpha: 0.9),
          padding: const EdgeInsets.all(12),
          child: const Text(
            'Daily caffeine limit exceeded',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
