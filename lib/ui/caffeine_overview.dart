import 'package:flutter/material.dart';

class CaffeineOverviewCard extends StatelessWidget {
  final int total;
  final int limit;

  const CaffeineOverviewCard({
    super.key,
    required this.total,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (total / limit).clamp(0.0, 1.5);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2A2A3E), const Color(0xFF1F1F2E)]
              : [const Color(0xFF2AFADF), const Color.fromARGB(255, 251, 251, 251)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color.fromARGB(255, 32, 32, 32) : const Color(0xFF2AFADF))
                .withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 700),
            builder: (_, value, __) => SizedBox(
              height: 160,
              width: 160,
              child: CircularProgressIndicator(
                value: value > 1 ? 1 : value,
                strokeWidth: 14,
                backgroundColor: Colors.white.withOpacity(0.2),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$total mg',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'of $limit mg',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
