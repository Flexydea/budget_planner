// lib/features/dashboard/widgets/progress_ring.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressRing extends StatelessWidget {
  final double progress; // 0..1
  final double size;
  final double stroke;
  final Color trackColor;
  final Color progressColor;
  final bool roundedCaps; // NEW: if true, looks nicer but less "exact" visually

  const ProgressRing({
    super.key,
    required this.progress,
    required this.size,
    required this.trackColor,
    required this.progressColor,
    this.stroke = 16,
    this.roundedCaps = false, // default to "precise" look
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0, 1),
          stroke: stroke,
          track: trackColor,
          color: progressColor,
          cap: roundedCaps ? StrokeCap.round : StrokeCap.butt,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final Color track;
  final Color color;
  final StrokeCap cap;

  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.track,
    required this.color,
    required this.cap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    final paintBase = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = cap;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2; // 12 o'clock

    // Track
    canvas.drawArc(rect, start, math.pi * 2, false, paintBase..color = track);

    // Progress
    final p = progress.clamp(0.0, 1.0);
    if (p >= 0.9995) {
      // ✅ full circle at 100% (arc with 2π won’t render fully)
      canvas.drawCircle(center, radius, paintBase..color = color);
    } else if (p > 0.0) {
      canvas.drawArc(
        rect,
        start,
        (math.pi * 2) * p,
        false,
        paintBase..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.stroke != stroke ||
      old.track != track ||
      old.color != color ||
      old.cap != cap;
}
