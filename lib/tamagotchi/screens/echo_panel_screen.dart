import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pet_model.dart';

/// Pantalla de selección de niveles - EchoPanel con carrusel horizontal de 6 niveles
class EchoPanelScreen extends StatefulWidget {
  final Function(int)? onLevelSelected;

  const EchoPanelScreen({
    super.key,
    this.onLevelSelected,
  });

  @override
  State<EchoPanelScreen> createState() => _EchoPanelScreenState();
}

class _EchoPanelScreenState extends State<EchoPanelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  final levelNames = [
    'EchoMimi Baby',
    'EchoMimi Friend',
    'EchoMimi Explorer',
    'EchoMimi Hero',
    'EchoMimi Savior',
    'EchoMimi Master',
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F8F8),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<PetModel>(
            builder: (context, pet, child) {
              final currentLevel = pet.level;

              return Stack(
                children: [
                  // Patrón decorativo en la parte superior
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(double.infinity, 150),
                      painter: _DotPatternPainter(),
                    ),
                  ),

                  // Contenido principal
                  Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (widget.onLevelSelected == null)
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF263238),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Título
                      const Text(
                        'EchoPanel',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF263238),
                          letterSpacing: -1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtítulo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          widget.onLevelSelected != null
                              ? 'Desliza para ver todos los niveles'
                              : 'Swipe to see all levels',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64B5F6),
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                        ),
                      ),

                      // Carrusel horizontal de 6 niveles
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 6, // 6 niveles
                          itemBuilder: (context, index) {
                            final level = index + 1;
                            final isUnlocked = currentLevel >= level;
                            final isCurrent = currentLevel == level;

                            return _buildLevelCarousel(
                              level: level,
                              isUnlocked: isUnlocked,
                              isCurrent: isCurrent,
                            );
                          },
                        ),
                      ),

                      const Spacer(),

                      // Indicadores de página
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF64B5F6)
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),

                  // Nubes decorativas en la parte inferior
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomClouds(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCarousel({
    required int level,
    required bool isUnlocked,
    required bool isCurrent,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  if (widget.onLevelSelected != null) {
                    widget.onLevelSelected!(level);
                  } else {
                    Navigator.pop(context);
                  }
                }
              : null,
          child: Transform.translate(
            offset: Offset(0, -15 * _floatController.value),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SVG del nivel
                Opacity(
                  opacity: isUnlocked ? 1.0 : 0.4,
                  child: SvgPicture.asset(
                    'assets/images/echomimi/level_$level.svg',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 8),

                // Sombra ovalada debajo
                if (isUnlocked)
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF90CAF9).withValues(alpha: 0.6),
                          const Color(0xFF90CAF9).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Etiqueta del nivel
                Text(
                  'Level $level',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked
                        ? const Color(0xFF263238)
                        : const Color(0xFFBDBDBD),
                  ),
                ),

                const SizedBox(height: 4),

                // Nombre del nivel
                Text(
                  levelNames[level - 1],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isUnlocked
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFFBDBDBD),
                  ),
                ),

                if (isCurrent) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomClouds() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned(
            left: -20,
            bottom: 0,
            child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                'assets/images/echomimi/cloud.svg',
                width: 150,
                height: 100,
              ),
            ),
          ),
          Positioned(
            right: -20,
            bottom: 0,
            child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                'assets/images/echomimi/cloud.svg',
                width: 140,
                height: 90,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: SvgPicture.asset(
                  'assets/images/echomimi/cloud.svg',
                  width: 180,
                  height: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64B5F6).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    for (var x = 0.0; x < size.width + 100; x += 15) {
      for (var y = 0.0; y < size.height; y += 15) {
        final opacity = 1.0 - (y / size.height) * 0.9 - (x / size.width) * 0.3;
        if (opacity > 0.1) {
          canvas.drawCircle(
            Offset(x - y * 0.5, y),
            2.5,
            paint..color = Color(0xFF64B5F6).withValues(alpha: 0.25 * opacity),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) => false;
}
