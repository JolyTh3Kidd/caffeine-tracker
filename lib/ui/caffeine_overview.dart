import 'package:flutter/material.dart';
import 'package:caffeine_tracker/l10n/app_localizations.dart';

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
    final exceeded = total > limit;

    return Card(
      margin: const EdgeInsets.all(20),
      // Theme comes from main.dart CardTheme
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: percent),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutQuart,
                    builder: (_, value, __) => CustomPaint(
                      painter: _ArcProgressPainter(
                        progress: value,
                        color: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$total',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            height: 1,
                            fontSize: 56,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.unitMg,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: exceeded
                            ? Colors.red.withValues(alpha: 0.2)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        exceeded
                            ? AppLocalizations.of(context)!.statusOverLimit
                            : AppLocalizations.of(context)!
                                .dailyGoalPercent((percent * 100).toInt()),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: exceeded
                                      ? Colors.red[300]
                                      : Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                    context,
                    AppLocalizations.of(context)!.dailyLimit,
                    '$limit ${AppLocalizations.of(context)!.unitMg}'),
                _buildInfoColumn(
                    context,
                    AppLocalizations.of(context)!.remaining,
                    '${(limit - total).clamp(0, limit)} ${AppLocalizations.of(context)!.unitMg}'),
              ],
            ),
            if (onManualAdjustment != null) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAdjustButton(context, -10),
                  const SizedBox(width: 16),
                  _buildAdjustButton(context, 50),
                  const SizedBox(width: 16),
                  _buildAdjustButton(context, 10),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildAdjustButton(BuildContext context, int amount) {
    final isPositive = amount > 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onManualAdjustment!(amount),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            '${isPositive ? "+" : ""}$amount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isPositive
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class _ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ArcProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = 135 * 3.14159 / 180;
    const sweepAngle = 270 * 3.14159 / 180;

    // Background Arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress Arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;

    final currentSweep = sweepAngle * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
