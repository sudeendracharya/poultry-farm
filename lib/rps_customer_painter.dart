import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromRGBO(248, 251, 255, 1)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.04, size.height * 0.29),
        Offset(size.width * 0.96, size.height * 0.29), [
      const Color.fromRGBO(248, 251, 255, 1),
      const Color.fromRGBO(248, 251, 255, 1)
    ], [
      0.00,
      1.00
    ]);

    Path path0 = Path();
    path0.moveTo(size.width * 0.0416667, size.height * 0.0742857);
    path0.quadraticBezierTo(size.width * 0.2093750, size.height * 0.4989286,
        size.width * 0.4575000, size.height * 0.5014286);
    path0.cubicTo(
        size.width * 0.4568750,
        size.height * 0.4360714,
        size.width * 0.4850000,
        size.height * 0.4342857,
        size.width * 0.4975000,
        size.height * 0.4328571);
    path0.cubicTo(
        size.width * 0.5414583,
        size.height * 0.4310714,
        size.width * 0.5372917,
        size.height * 0.4785714,
        size.width * 0.5416667,
        size.height * 0.5014286);
    path0.quadraticBezierTo(size.width * 0.7908333, size.height * 0.5010714,
        size.width * 0.9583333, size.height * 0.0714286);
    path0.lineTo(size.width * 0.0416667, size.height * 0.0742857);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
