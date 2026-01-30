import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';

class LoginBackgroundPainter extends CustomPainter {
  LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFFF6F6F8), Colors.white],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final topGlowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primary.withValues(alpha: 0.06), Colors.transparent],
      ).createShader(Offset.zero & Size(size.width, size.height * 0.5));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.5),
      topGlowPaint,
    );

    final topCirclePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.9, -size.height * 0.05),
      size.width * 0.45,
      topCirclePaint,
    );

    final bottomCirclePaint = Paint()
      ..color = Colors.blue.shade400.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 1.05),
      size.width * 0.35,
      bottomCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant LoginBackgroundPainter oldDelegate) {
    return true;
  }
}
