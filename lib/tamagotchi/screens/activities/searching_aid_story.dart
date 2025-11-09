import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Historia interactiva "Searching Aid"
class SearchingAidStory extends StatefulWidget {
  const SearchingAidStory({super.key});

  @override
  State<SearchingAidStory> createState() => _SearchingAidStoryState();
}

class _SearchingAidStoryState extends State<SearchingAidStory> {
  int _currentPage = 0;

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
                            Icons.menu_book_rounded,
                            color: Color(0xFF5A7A8F),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Título
                    const Text(
                      'Searching Aid',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A202C),
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Paneles de la historia
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildStoryPanel(
                            text: 'Today was really cute. Don\'t tell anyone not was feeling',
                            useEmoji: true,
                            emoji: '😊',
                            hasButton: true,
                            buttonText: 'How do you feel?',
                          ),
                          const SizedBox(height: 16),
                          _buildStoryPanel(
                            text: 'I feel free expression on...',
                            useSvg: true,
                            hasButton: true,
                            buttonText: 'What happened?',
                          ),
                          const SizedBox(height: 16),
                          _buildStoryPanel(
                            text: 'Conversation continues...',
                            useIcon: true,
                            icon: Icons.person,
                            hasButton: true,
                            buttonText: 'Tell an adult trusted',
                          ),
                          const SizedBox(height: 16),
                          _buildStoryPanel(
                            text: 'You have gained a trust badge for successfully helping someone!',
                            useIcon: true,
                            icon: Icons.verified,
                            iconColor: Colors.amber,
                            hasButton: false,
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

  Widget _buildStoryPanel({
    required String text,
    bool useEmoji = false,
    String emoji = '',
    bool useSvg = false,
    bool useIcon = false,
    IconData icon = Icons.person,
    Color iconColor = const Color(0xFF7BA9D1),
    bool hasButton = false,
    String buttonText = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7BA9D1).withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personaje o emoji
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: useIcon ? iconColor.withValues(alpha: 0.2) : const Color(0xFF7BA9D1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: useEmoji
                      ? Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        )
                      : useSvg
                          ? SvgPicture.asset(
                              'assets/images/echomimi/cloud.svg',
                              width: 40,
                              height: 40,
                            )
                          : Icon(
                              icon,
                              size: 32,
                              color: iconColor,
                            ),
                ),
              ),
              const SizedBox(width: 12),
              // Texto
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1A202C),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasButton) ...[
            const SizedBox(height: 12),
            Material(
              color: const Color(0xFF7BA9D1),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
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
