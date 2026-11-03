import 'dart:ui';

import 'package:flutter/material.dart';

/// Kotak putus-putus (dipakai di kamera: "Tulisan kamu di sini").
class DashedBox extends StatelessWidget {
  final Color color;
  final double radius;
  final double strokeWidth;
  final Widget? child;

  const DashedBox({
    super.key,
    this.color = Colors.white,
    this.radius = 20,
    this.strokeWidth = 3,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(color, radius, strokeWidth),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;

  _DashedPainter(this.color, this.radius, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 12), paint);
        d += 22;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color || old.radius != radius || old.strokeWidth != strokeWidth;
}
