import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ScratchPoint {
  ScratchPoint(this.position, this.size);

  // Null position is dedicated for point which closes the continuous drawing
  final Offset? position;
  final double size;
}

class CardPainter extends CustomPainter {
  final List<ScratchPoint?> scratchPoints;

  final Color color;

  final BoxFit? boxFit;

  final void Function(Size) onDraw;

  final ui.Image? image;

  CardPainter({
    required this.color,
    required this.onDraw,
    required this.scratchPoints,
    this.image,
    this.boxFit,
  });

  Paint _mainPaint(double strokeW) {
    final tempPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.transparent
      ..blendMode = ui.BlendMode.src
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke;
    return tempPaint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    onDraw(size);

    canvas.saveLayer(null, Paint());

    final rect = ui.Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..color = color);
    if (image != null && boxFit != null) {
      final imgSize = Size(image!.width.toDouble(), image!.height.toDouble());
      final boxFitApply = applyBoxFit(boxFit!, imgSize, size);
      final inpSubRect =
          Alignment.center.inscribe(boxFitApply.source, Offset.zero & imgSize);
      final outSubRect =
          Alignment.center.inscribe(boxFitApply.destination, rect);

      canvas.drawImageRect(
        image!,
        inpSubRect,
        outSubRect,
        Paint(),
      );
    }

    var path = Path();
    var isStarted = false;
    ScratchPoint? previousPoint;

    for (final point in scratchPoints) {
      if (point == null) {
        if (previousPoint != null) {
          canvas.drawPath(path, _mainPaint(previousPoint.size));
        }

        path = Path();
        isStarted = false;
      } else {
        final pose = point.position;
        if (!isStarted) {
          isStarted = true;
          path.moveTo(pose!.dx, pose.dy);
        } else {
          path.lineTo(pose!.dx, pose.dy);
        }
      }
      previousPoint = point;
    }

    if (previousPoint != null) {
      canvas.drawPath(path, _mainPaint(previousPoint.size));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
