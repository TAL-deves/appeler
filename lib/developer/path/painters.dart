import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    canvas.drawLine(
      Offset(size.width * 1 / 6, size.height * 1 / 2),
      Offset(size.width * 5 / 6, size.height * 1 / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final a = Offset(size.width * 1 / 6, size.height * 1 / 4);
    final b = Offset(size.width * 5 / 6, size.height * 3 / 4);

    const radius = Radius.circular(16);
    final rect = Rect.fromPoints(a, b);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final circle = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      circle,
      size.width * 1 / 4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final arc1 = Path();
    arc1.moveTo(size.width * 0.2, size.height * 0.2);
    arc1.arcToPoint(
      Offset(size.width * 0.8, size.height * 0.2),
      radius: const Radius.circular(250),
      clockwise: false,
    );
    canvas.drawPath(arc1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TrianglePainter extends CustomPainter {
  final bool filled;
  final Color color;
  final double strokeWidth;

  TrianglePainter({
    this.filled = true,
    this.color = Colors.transparent,
    this.strokeWidth = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PolygonPainter extends CustomPainter {
  final double radius;
  final int sides;
  final Color color;

  const PolygonPainter({
    required this.radius,
    required this.sides,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double angle = (2 * 3.14159) / sides;
    final double halfAngle = angle / 2;

    final Path path = Path();

    double x = centerX + radius * cos(-halfAngle);
    double y = centerY + radius * sin(-halfAngle);
    path.moveTo(x, y);

    for (int i = 0; i < sides; i++) {
      x = centerX + radius * cos(angle * i - halfAngle);
      y = centerY + radius * sin(angle * i - halfAngle);
      path.lineTo(x, y);
    }

    path.close();

    final Paint paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ChorkiPainter extends CustomPainter {
  final double radius;
  final int numPoints;
  final Color color;

  const ChorkiPainter({
    required this.radius,
    this.numPoints = 5,
    this.color = Colors.orange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double angle = (2 * 3.14159) / numPoints;
    final double halfAngle = angle / 2;

    final Path path = Path();

    double x = centerX + radius * cos(-halfAngle);
    double y = centerY + radius * sin(-halfAngle);
    path.moveTo(x, y);

    for (int i = 0; i < numPoints; i++) {
      x = centerX + radius * cos(angle * i - halfAngle);
      y = centerY + radius * sin(angle * i - halfAngle);
      path.lineTo(x, y);

      x = centerX + radius / 2 * cos(angle * i + halfAngle);
      y = centerY + radius / 2 * sin(angle * i + halfAngle);
      path.lineTo(x, y);
    }

    path.close();

    final Paint paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImage(image, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ImagePaintWidget extends StatefulWidget {
  const ImagePaintWidget({Key? key}) : super(key: key);

  @override
  State<ImagePaintWidget> createState() => _ImagePaintWidgetState();
}

class _ImagePaintWidgetState extends State<ImagePaintWidget> {
  ui.Image? image;

  @override
  Widget build(BuildContext context) {
    return image == null
        ? const CircularProgressIndicator()
        : SizedBox(
            width: 400,
            height: 400,
            child: FittedBox(
              child: SizedBox(
                height: image!.height.toDouble(),
                width: image!.width.toDouble(),
                child: CustomPaint(
                  painter: ImagePainter(image!),
                ),
              ),
            ),
          );
  }

  @override
  void initState() {
    loadImage("assets/images/welcome_img_1.png");
    super.initState();
  }

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      this.image = image;
    });
  }
}
