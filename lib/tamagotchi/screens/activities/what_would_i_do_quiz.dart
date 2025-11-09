import 'package:flutter/material.dart';

/// Quiz "What would I do?"
class WhatWouldIDoQuiz extends StatefulWidget {
  const WhatWouldIDoQuiz({super.key});

  @override
  State<WhatWouldIDoQuiz> createState() => _WhatWouldIDoQuizState();
}

class _WhatWouldIDoQuizState extends State<WhatWouldIDoQuiz> {
  int _currentQuestion = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '1. Someone you don\'t know messages you saying "You\'re really cute, can we talk in private?"',
      'options': [
        'Say "thanks" and send your cell phone number.',
        'Keep chatting to see who they are.',
        'I know answering but marks no little relevance.',
      ],
    },
    {
      'question': '2. You open a new Instagram and it shows an inappropriate photo.',
      'options': [
        'Close it immediately and tell an adult you trust.',
        'Share it with your friends.',
        'Comment on the post to ask why they sent it.',
      ],
    },
    // Agrega más preguntas aquí
  ];

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
                            Icons.help_outline_rounded,
                            color: Color(0xFF5A7A8F),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Título
                    const Text(
                      'What would I\ndo?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A202C),
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Preguntas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _questions[_currentQuestion]['question'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...(_questions[_currentQuestion]['options'] as List<String>)
                              .map((option) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(right: 8, top: 2),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFFBDBDBD),
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF4A5568),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
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
