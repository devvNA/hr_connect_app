import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class AttendanceDonut extends StatelessWidget {
  final double percentage;
  final int lateCount;
  final int absentCount;

  const AttendanceDonut({
    super.key,
    required this.percentage,
    required this.lateCount,
    required this.absentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _DonutChartPainter(
                percentage: percentage,
                color: AppColors.primary,
                backgroundColor: Colors.grey[200]!,
              ),
              child: Center(
                child: Container(
                  width: 80, // Inner circle to create donut effect
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'PRESENT',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Late', lateCount.toString()),
              _buildStatItem('Absent', absentCount.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textLight),
        ),
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  _DonutChartPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw conic gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -pi / 2; // Start from top
    final sweepAngle = 2 * pi * percentage;

    // Use a shader for the gradient look if desired, or simple color
    // The HTML reference used a conic gradient.
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [color, color.withValues(alpha: 0.8)],
      // Simplified gradient for Flutter, mimicking the CSS conic
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style =
          PaintingStyle.fill; // We fill, then use inner circle widget to mask

    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
