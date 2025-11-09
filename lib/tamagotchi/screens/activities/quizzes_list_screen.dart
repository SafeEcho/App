import 'package:flutter/material.dart';
import 'what_would_i_do_quiz.dart';

/// Pantalla que muestra la lista de quizzes disponibles
class QuizzesListScreen extends StatelessWidget {
  const QuizzesListScreen({super.key});

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
              // Patrón de puntos decorativo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 200),
                  painter: _DotPatternPainter(),
                ),
              ),

              Column(
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Quizzes',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A202C),
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Lista de quizzes
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildQuizCard(
                          context,
                          title: 'What would I do?',
                          icon: Icons.help_outline_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WhatWouldIDoQuiz(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF7BA9D1).withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
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
