import 'package:flutter/material.dart';

/// Ejercicio de Grounding
class GroundingExercise extends StatelessWidget {
  const GroundingExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F4F8),
              Color(0xFFF5F7FA),
              Color(0xFFFAFBFC),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Patrón de puntos
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 200),
                  painter: _DotPatternPainter(),
                ),
              ),

              SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF5A7A8F),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.favorite,
                            color: Color(0xFF5A7A8F),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Título
                    const Text(
                      'Grounding',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A202C),
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Lista de los 5 sentidos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          _buildSenseItem(
                            number: 5,
                            text: 'things I can see',
                            iconData: Icons.visibility_rounded,
                          ),
                          const SizedBox(height: 20),
                          _buildSenseItem(
                            number: 4,
                            text: 'things I can touch',
                            iconData: Icons.pan_tool_rounded,
                          ),
                          const SizedBox(height: 20),
                          _buildSenseItem(
                            number: 3,
                            text: 'things I can hear',
                            iconData: Icons.music_note_rounded,
                          ),
                          const SizedBox(height: 20),
                          _buildSenseItem(
                            number: 2,
                            text: 'things I can smell',
                            iconData: Icons.local_florist_rounded,
                          ),
                          const SizedBox(height: 20),
                          _buildSenseItem(
                            number: 1,
                            text: 'things I can taste',
                            iconData: Icons.restaurant_rounded,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSenseItem({
    required int number,
    required String text,
    required IconData iconData,
  }) {
    return Row(
      children: [
        // Número
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF7BA9D1).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF7BA9D1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Texto
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7BA9D1),
            ),
          ),
        ),
        // Icono
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF7BA9D1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8AACBF).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    const dotRadius = 3.0;
    const spacing = 20.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final opacity = 1.0 - (y / size.height);
        paint.color = Color(0xFF8AACBF).withValues(alpha: 0.3 * opacity);
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
