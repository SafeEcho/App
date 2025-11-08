import 'package:flutter/material.dart';
import '../pet_model.dart';

/// Widget animado de la mascota virtual
class PetWidget extends StatefulWidget {
  final PetMood mood;
  final bool isSleeping;
  final double size;

  const PetWidget({
    super.key,
    required this.mood,
    required this.isSleeping,
    this.size = 150,
  });

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Parpadeo aleatorio
    _startBlinkLoop();
  }

  void _startBlinkLoop() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 2 + (DateTime.now().second % 3)));
      if (mounted && !widget.isSleeping) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sombra ovalada debajo de la nube
        Positioned(
          bottom: 0,
          child: Container(
            width: widget.size * 0.8,
            height: widget.size * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: RadialGradient(
                colors: [
                  Colors.blue.shade300.withOpacity(0.4),
                  Colors.blue.shade300.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Nube kawaii
        AnimatedBuilder(
          animation: _blinkController,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size * 0.85),
              painter: _CloudPetPainter(
                mood: widget.mood,
                isSleeping: widget.isSleeping,
                blinkValue: _blinkController.value,
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getBodyColor() {
    if (widget.isSleeping) return Colors.indigo;

    switch (widget.mood) {
      case PetMood.happy:
        return Colors.yellow.shade600;
      case PetMood.sad:
        return Colors.blue.shade300;
      case PetMood.sleepy:
        return Colors.indigo.shade300;
      case PetMood.excited:
        return Colors.orange;
      case PetMood.sick:
        return Colors.green.shade300;
      case PetMood.learning:
        return Colors.purple.shade400;
    }
  }
}

/// Painter personalizado para dibujar la nube kawaii
class _CloudPetPainter extends CustomPainter {
  final PetMood mood;
  final bool isSleeping;
  final double blinkValue;

  _CloudPetPainter({
    required this.mood,
    required this.isSleeping,
    required this.blinkValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Dibujar la forma de nube
    _drawCloud(canvas, size, center);

    // Dibujar brazos/pies si está feliz
    if (mood == PetMood.happy || mood == PetMood.excited) {
      _drawLimbs(canvas, size, center);
    }

    // Ojos
    _drawEyes(canvas, size, center);

    // Boca
    _drawMouth(canvas, size, center);

    // Mejillas sonrojadas
    _drawBlush(canvas, size, center);

    // Accesorios según el mood
    _drawAccessories(canvas, size, center);
  }

  void _drawCloud(Canvas canvas, Size size, Offset center) {
    final cloudPaint = Paint()
      ..color = const Color(0xFFE3F2FD) // Azul muy claro
      ..style = PaintingStyle.fill;

    final cloudPath = Path();

    // Cuerpo principal de la nube (círculo central más grande)
    final mainCircle = Offset(center.dx, center.dy);
    canvas.drawCircle(mainCircle, size.width * 0.25, cloudPaint);

    // Círculos laterales para dar forma de nube
    // Izquierda superior
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.08),
      size.width * 0.18,
      cloudPaint,
    );

    // Derecha superior
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.08),
      size.width * 0.18,
      cloudPaint,
    );

    // Izquierda inferior
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.12),
      size.width * 0.15,
      cloudPaint,
    );

    // Derecha inferior
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.15, center.dy + size.height * 0.12),
      size.width * 0.15,
      cloudPaint,
    );

    // Sombra/contorno suave
    final shadowPaint = Paint()
      ..color = const Color(0xFFBBDEFB).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Círculos de sombra en la parte inferior
    canvas.drawCircle(
      Offset(center.dx, center.dy + size.height * 0.15),
      size.width * 0.22,
      shadowPaint,
    );
  }

  void _drawLimbs(Canvas canvas, Size size, Offset center) {
    final limbPaint = Paint()
      ..color = const Color(0xFFE3F2FD)
      ..style = PaintingStyle.fill;

    // Brazos pequeños a los lados
    // Brazo izquierdo
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.35, center.dy),
      size.width * 0.08,
      limbPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.42, center.dy + size.height * 0.05),
      size.width * 0.06,
      limbPaint,
    );

    // Brazo derecho
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.35, center.dy),
      size.width * 0.08,
      limbPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.42, center.dy + size.height * 0.05),
      size.width * 0.06,
      limbPaint,
    );

    // Pies pequeños abajo
    // Pie izquierdo
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.1, center.dy + size.height * 0.28),
      size.width * 0.07,
      limbPaint,
    );

    // Pie derecho
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.1, center.dy + size.height * 0.28),
      size.width * 0.07,
      limbPaint,
    );
  }

  void _drawBlush(Canvas canvas, Size size, Offset center) {
    final blushPaint = Paint()
      ..color = Colors.pink.shade200.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Mejilla izquierda
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.2, center.dy + size.height * 0.05),
        width: size.width * 0.12,
        height: size.height * 0.08,
      ),
      blushPaint,
    );

    // Mejilla derecha
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.2, center.dy + size.height * 0.05),
        width: size.width * 0.12,
        height: size.height * 0.08,
      ),
      blushPaint,
    );
  }

  void _drawEyes(Canvas canvas, Size size, Offset center) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final leftEyeX = center.dx - size.width * 0.12;
    final rightEyeX = center.dx + size.width * 0.12;
    final eyeY = center.dy - size.height * 0.05;

    if (isSleeping) {
      // Ojos cerrados (líneas curvas felices)
      final linePaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Ojo izquierdo cerrado (curva)
      final leftPath = Path();
      leftPath.moveTo(leftEyeX - 8, eyeY);
      leftPath.quadraticBezierTo(leftEyeX, eyeY + 4, leftEyeX + 8, eyeY);
      canvas.drawPath(leftPath, linePaint);

      // Ojo derecho cerrado (curva)
      final rightPath = Path();
      rightPath.moveTo(rightEyeX - 8, eyeY);
      rightPath.quadraticBezierTo(rightEyeX, eyeY + 4, rightEyeX + 8, eyeY);
      canvas.drawPath(rightPath, linePaint);

      // Zzz
      _drawZzz(canvas, center, size);
    } else {
      // Ojos estilo kawaii (círculos negros grandes y brillantes)
      final eyeSize = size.width * 0.055 * (1 - blinkValue);

      if (eyeSize > 0) {
        // Ojo izquierdo
        canvas.drawCircle(Offset(leftEyeX, eyeY), eyeSize, eyePaint);

        // Ojo derecho
        canvas.drawCircle(Offset(rightEyeX, eyeY), eyeSize, eyePaint);

        // Brillos blancos en los ojos (hace que se vean más kawaii)
        final shinePaint = Paint()..color = Colors.white;

        // Brillo grande
        canvas.drawCircle(
          Offset(leftEyeX - eyeSize * 0.3, eyeY - eyeSize * 0.3),
          eyeSize * 0.35,
          shinePaint,
        );
        canvas.drawCircle(
          Offset(rightEyeX - eyeSize * 0.3, eyeY - eyeSize * 0.3),
          eyeSize * 0.35,
          shinePaint,
        );

        // Brillo pequeño
        canvas.drawCircle(
          Offset(leftEyeX + eyeSize * 0.4, eyeY + eyeSize * 0.2),
          eyeSize * 0.18,
          shinePaint,
        );
        canvas.drawCircle(
          Offset(rightEyeX + eyeSize * 0.4, eyeY + eyeSize * 0.2),
          eyeSize * 0.18,
          shinePaint,
        );
      }
    }
  }

  void _drawMouth(Canvas canvas, Size size, Offset center) {
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + size.height * 0.08;

    if (isSleeping) {
      // Boca pequeña (durmiendo) - círculo pequeño
      canvas.drawCircle(
        Offset(center.dx, mouthY),
        3,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill,
      );
    } else {
      final path = Path();

      switch (mood) {
        case PetMood.happy:
        case PetMood.excited:
          // Sonrisa kawaii (semi-círculo)
          path.moveTo(center.dx - 15, mouthY);
          path.quadraticBezierTo(
            center.dx,
            mouthY + 10,
            center.dx + 15,
            mouthY,
          );
          break;

        case PetMood.sad:
          // Boca triste pequeña
          path.moveTo(center.dx - 12, mouthY + 5);
          path.quadraticBezierTo(
            center.dx,
            mouthY,
            center.dx + 12,
            mouthY + 5,
          );
          break;

        case PetMood.sleepy:
          // Bostezo pequeño
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(center.dx, mouthY),
              width: 18,
              height: 24,
            ),
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.fill,
          );
          return;

        case PetMood.sick:
          // Boca ondulada (mareado)
          path.moveTo(center.dx - 15, mouthY);
          path.quadraticBezierTo(
            center.dx - 7,
            mouthY + 4,
            center.dx,
            mouthY,
          );
          path.quadraticBezierTo(
            center.dx + 7,
            mouthY - 4,
            center.dx + 15,
            mouthY,
          );
          break;

        case PetMood.learning:
          // Sonrisa concentrada
          path.moveTo(center.dx - 12, mouthY);
          path.lineTo(center.dx + 12, mouthY);
          break;
      }

      canvas.drawPath(path, mouthPaint);
    }
  }

  void _drawAccessories(Canvas canvas, Size size, Offset center) {
    switch (mood) {
      case PetMood.excited:
        // Estrellas alrededor
        _drawStars(canvas, center, size);
        break;

      case PetMood.sick:
        // Espirales mareado
        _drawDizzySpirals(canvas, center, size);
        break;

      case PetMood.learning:
        // Gorro de graduación
        _drawGraduationCap(canvas, center, size);
        break;

      default:
        break;
    }
  }

  void _drawZzz(Canvas canvas, Offset center, Size size) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Z',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Tres Z's de diferentes tamaños
    for (var i = 0; i < 3; i++) {
      final offset = Offset(
        center.dx + 40 + i * 15,
        center.dy - 60 - i * 10,
      );
      textPainter.paint(canvas, offset);
    }
  }

  void _drawStars(Canvas canvas, Offset center, Size size) {
    final starPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final positions = [
      Offset(center.dx - 60, center.dy - 40),
      Offset(center.dx + 60, center.dy - 40),
      Offset(center.dx - 50, center.dy + 40),
      Offset(center.dx + 50, center.dy + 40),
    ];

    for (final pos in positions) {
      _drawStar(canvas, pos, 10, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159) / 5 - 3.14159 / 2;
      final x = center.dx + size * (i % 2 == 0 ? 1 : 0.5) * cos(angle);
      final y = center.dy + size * (i % 2 == 0 ? 1 : 0.5) * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => angle.cos();
  double sin(double angle) => angle.sin();

  void _drawDizzySpirals(Canvas canvas, Offset center, Size size) {
    final spiralPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Espiral izquierda
    _drawSpiral(canvas, Offset(center.dx - 60, center.dy - 60), spiralPaint);
    // Espiral derecha
    _drawSpiral(canvas, Offset(center.dx + 60, center.dy - 60), spiralPaint);
  }

  void _drawSpiral(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy);

    for (var i = 0; i < 20; i++) {
      final angle = i * 0.5;
      final radius = i * 1.5;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  void _drawGraduationCap(Canvas canvas, Offset center, Size size) {
    final capPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Base del gorro
    final rect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - size.height * 0.45),
      width: 60,
      height: 8,
    );
    canvas.drawRect(rect, capPaint);

    // Parte superior cuadrada
    final topRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - size.height * 0.52),
      width: 70,
      height: 5,
    );
    canvas.drawRect(topRect, capPaint);

    // Borla
    canvas.drawCircle(
      Offset(center.dx + 30, center.dy - size.height * 0.52),
      5,
      Paint()..color = Colors.amber,
    );
  }

  @override
  bool shouldRepaint(_CloudPetPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.isSleeping != isSleeping ||
        oldDelegate.blinkValue != blinkValue;
  }
}

extension on double {
  double cos() => (this * 180 / 3.14159).toCos();
  double sin() => (this * 180 / 3.14159).toSin();
}

extension on double {
  double toCos() {
    // Aproximación simple de coseno
    final rad = this * 3.14159 / 180;
    return rad.cosApprox();
  }

  double toSin() {
    // Aproximación simple de seno
    final rad = this * 3.14159 / 180;
    return rad.sinApprox();
  }

  double cosApprox() {
    // Taylor series approximation
    return 1 - (this * this) / 2 + (this * this * this * this) / 24;
  }

  double sinApprox() {
    // Taylor series approximation
    return this - (this * this * this) / 6 + (this * this * this * this * this) / 120;
  }
}
