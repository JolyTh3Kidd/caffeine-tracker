import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double percent;
  final int total;
  const ProgressRing({super.key, required this.percent, required this.total});

  Color get color {
    if (percent < 0.7) return Colors.green;
    if (percent <= 1.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: percent),
        duration: const Duration(milliseconds: 600),
        builder: (_, value, __) => CircularProgressIndicator(
          value: value.clamp(0.0, 1.0),
          strokeWidth: 12,
          color: color,
        ),
      ),
    );
  }
}