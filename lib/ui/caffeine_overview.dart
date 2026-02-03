import 'package:flutter/material.dart';

class CaffeineOverviewCard extends StatelessWidget {
  final int total;
  final int limit;
  final Function(int)? onManualAdjustment;

  const CaffeineOverviewCard({
    super.key,
    required this.total,
    required this.limit,
    this.onManualAdjustment,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (total / limit).clamp(0.0, 1.5);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exceeded = total > limit;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Custom progress ring with better styling
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: CustomPaint(
                      painter: _ProgressRingPainter(
                        progress: value > 1 ? 1 : value,
                        backgroundColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF0F0F0),
                        foregroundColor: exceeded
                            ? Colors.red[400]!
                            : const Color(0xFF6F4E37),
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$total',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                      ),
                      Text(
                        'mg',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFAFAFA),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Limit',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$limit mg',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (onManualAdjustment != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAdjustButton(context, -10, isDark),
                const SizedBox(width: 16),
                _buildAdjustButton(context, 10, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAdjustButton(BuildContext context, int amount, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onManualAdjustment!(amount),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                amount > 0 ? Icons.add : Icons.remove,
                size: 16,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
              const SizedBox(width: 4),
              Text(
                '10 mg',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final sweepAngle = (progress * 2 * 3.14159265359);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265359 / 2, // Start from top
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.foregroundColor != foregroundColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
