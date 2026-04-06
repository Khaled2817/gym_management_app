import 'dart:math' as math;
import 'package:flutter/material.dart';

class DotsCircleLoader extends StatefulWidget {
  const DotsCircleLoader({
    super.key,
    this.size = 64,
    this.dotColor = const Color(0xFF2196F3),
    this.dotCount = 8,
    this.duration = const Duration(milliseconds: 900),
    this.minDotScale = 0.45,
    this.maxDotScale = 1.0,
  });

  final double size;
  final Color dotColor;
  final int dotCount;
  final Duration duration;
  final double minDotScale;
  final double maxDotScale;

  @override
  State<DotsCircleLoader> createState() => _DotsCircleLoaderState();
}

class _DotsCircleLoaderState extends State<DotsCircleLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          return CustomPaint(
            painter: _DotsPainter(
              t: _c.value,
              dotColor: widget.dotColor,
              dotCount: widget.dotCount,
              minScale: widget.minDotScale,
              maxScale: widget.maxDotScale,
            ),
          );
        },
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({
    required this.t,
    required this.dotColor,
    required this.dotCount,
    required this.minScale,
    required this.maxScale,
  });

  final double t; // 0..1
  final Color dotColor;
  final int dotCount;
  final double minScale;
  final double maxScale;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.33;
    final baseDotR = size.shortestSide * 0.06;

    final paint = Paint()..color = dotColor;

    // نعمل دوران + اختلاف حجم بسيط للنقاط (زي الصورة)
    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi / dotCount) * i + (2 * math.pi * t);

      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);

      // النقطة اللي قدام تكبر، واللي ورا تصغر
      final phase = (i / dotCount + t) % 1.0;
      final scale = lerpDouble(minScale, maxScale, _easeOut(1 - phase))!;

      canvas.drawCircle(Offset(dx, dy), baseDotR * scale, paint);
    }
  }

  double _easeOut(double x) => 1 - math.pow(1 - x, 2).toDouble();

  double? lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.minScale != minScale ||
        oldDelegate.maxScale != maxScale;
  }
}