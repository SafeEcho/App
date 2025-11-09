import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Juego "Emotions & Screens"
class EmotionsScreensGame extends StatefulWidget {
  const EmotionsScreensGame({super.key});

  @override
  State<EmotionsScreensGame> createState() => _EmotionsScreensGameState();
}

class _EmotionsScreensGameState extends State<EmotionsScreensGame> {
  bool _showInstructions = true;

  @override
  Widget build(BuildContext context) {
    if (_showInstructions) {
      return _buildInstructions();
    }
    return _buildGame();
  }

  Widget _buildInstructions() {
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
                        const Spacer(),
                        const Icon(
                          Icons.videogame_asset,
                          color: Color(0xFF5A7A8F),
                          size: 24,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Emotions &\nScreens',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A202C),
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Card de instrucciones
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF7BA9D1).withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'INSTRUCTIONS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A202C),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Match the corresponding emotion to the presented digital situation (either safe or risky).',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4A5568),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Emojis
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 16,
                            children: [
                              _buildEmoji('😊', 'Happy'),
                              _buildEmoji('😢', 'Sad'),
                              _buildEmoji('😠', 'Angry'),
                              _buildEmoji('😱', 'Scared'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Botón START
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Material(
                      color: const Color(0xFF7BA9D1),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showInstructions = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          child: const Text(
                            'START',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Nubes decorativas
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: SvgPicture.asset(
                            'assets/images/echomimi/cloud.svg',
                            width: 100,
                            height: 70,
                          ),
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: SvgPicture.asset(
                            'assets/images/echomimi/cloud.svg',
                            width: 120,
                            height: 80,
                          ),
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

  Widget _buildEmoji(String emoji, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
      ],
    );
  }

  Widget _buildGame() {
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
                            Icons.videogame_asset,
                            color: Color(0xFF5A7A8F),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Título
                    const Text(
                      'Emotions &\nScreens',
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

                    // Contenido del juego
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF7BA9D1).withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Matching game implementation here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4A5568),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'emojis_matching.svg',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
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
