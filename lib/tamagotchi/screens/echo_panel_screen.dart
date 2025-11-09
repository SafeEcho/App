import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pet_model.dart';
import 'level_detail_screen.dart';
import 'activities/minigames_list_screen.dart';
import 'activities/stories_list_screen.dart';
import 'activities/quizzes_list_screen.dart';
import 'activities/exercises_list_screen.dart';

/// Pantalla de selección de niveles - EchoPanel con PageView horizontal deslizable
class EchoPanelScreen extends StatefulWidget {
  final Function(int)? onLevelSelected;
  final bool showActivitiesPanel;

  const EchoPanelScreen({
    super.key,
    this.onLevelSelected,
    this.showActivitiesPanel = false,
  });

  @override
  State<EchoPanelScreen> createState() => _EchoPanelScreenState();
}

class _EchoPanelScreenState extends State<EchoPanelScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late PageController _pageController;
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

    _pageController = PageController(
      viewportFraction: 0.5, // Muestra 3 niveles a la vez (centro + parciales a los lados)
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si showActivitiesPanel es true, mostrar el panel de actividades
    if (widget.showActivitiesPanel) {
      return _buildActivitiesPanel();
    }

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
          child: Consumer<PetModel>(
            builder: (context, pet, child) {
              final currentLevel = pet.level;

              return Stack(
                children: [
                  // Nube decorativa superior izquierda
                  Positioned(
                    top: -30,
                    left: -40,
                    child: Opacity(
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 120,
                        height: 80,
                      ),
                    ),
                  ),

                  // Estrellas superiores derecha
                  Positioned(
                    top: 50,
                    right: 30,
                    child: SvgPicture.asset(
                      'assets/images/echomimi/stars.svg',
                      width: 60,
                      height: 60,
                    ),
                  ),

                  // Nube decorativa inferior derecha
                  Positioned(
                    bottom: 40,
                    right: -40,
                    child: Opacity(
                      opacity: 0.5,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 150,
                        height: 100,
                      ),
                    ),
                  ),

                  // Nube decorativa inferior izquierda
                  Positioned(
                    bottom: 60,
                    left: -30,
                    child: Opacity(
                      opacity: 0.4,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 130,
                        height: 90,
                      ),
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
                                  color: Color(0xFF1A202C),
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
                          color: Color(0xFF1A202C),
                          letterSpacing: -1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtítulo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Complete each level\'s required tasks to\nunlock the next EchoMimi!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF64B5F6),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // PageView horizontal con los 6 niveles
                      Expanded(
                        child: _buildLevelsPageView(currentLevel),
                      ),

                      const SizedBox(height: 20),

                      // Indicadores de página
                      _buildPageIndicators(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Construye el PageView con todos los 6 niveles
  Widget _buildLevelsPageView(int currentLevel) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemCount: 6,
      itemBuilder: (context, index) {
        final level = index + 1;
        final isUnlocked = currentLevel >= level;

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double scale = 1.0;
            if (_pageController.position.haveDimensions) {
              final page = _pageController.page ?? 0;
              final delta = (page - index).abs();
              scale = 1.0 - (delta * 0.3).clamp(0.0, 0.3);
            }

            return Transform.scale(
              scale: scale,
              child: _buildLevelItem(
                level: level,
                isUnlocked: isUnlocked,
                isCentral: index == _currentPage,
              ),
            );
          },
        );
      },
    );
  }

  /// Construye los indicadores de página (dots)
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFF60A5FA)
                : const Color(0xFF60A5FA).withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }

  /// Construye un ítem de nivel individual
  Widget _buildLevelItem({
    required int level,
    required bool isUnlocked,
    required bool isCentral,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  // Si es el nivel 2, navegar a la pantalla de detalle
                  if (level == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelDetailScreen(
                          level: level,
                          levelName: levelNames[level - 1],
                        ),
                      ),
                    );
                  } else if (widget.onLevelSelected != null) {
                    widget.onLevelSelected!(level);
                  }
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SVG del personaje con animación de flotación
                Transform.translate(
                  offset: Offset(0, -10 * _floatController.value),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: const Color(0xFF60A5FA).withValues(alpha: 0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: Opacity(
                      opacity: isUnlocked ? 1.0 : 0.35,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/level_$level.svg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Plataforma/círculo de tierra debajo del personaje
                Container(
                  width: 120,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: RadialGradient(
                      colors: isUnlocked
                          ? [
                              const Color(0xFF5A9FD4).withValues(alpha: 0.7),
                              const Color(0xFF5A9FD4).withValues(alpha: 0.4),
                              const Color(0xFF5A9FD4).withValues(alpha: 0.15),
                              Colors.transparent,
                            ]
                          : [
                              const Color(0xFFBDBDBD).withValues(alpha: 0.4),
                              const Color(0xFFBDBDBD).withValues(alpha: 0.2),
                              const Color(0xFFBDBDBD).withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Label del nivel
                Text(
                  'Level $level',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isUnlocked
                        ? const Color(0xFF1A202C)
                        : const Color(0xFFBDBDBD),
                  ),
                ),

                const SizedBox(height: 6),

                // Nombre del nivel
                Text(
                  levelNames[level - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construye el panel de actividades con los 4 botones
  Widget _buildActivitiesPanel() {
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
                  const SizedBox(height: 40),

                  // Título
                  const Text(
                    'EchoPanel',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A202C),
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Grid de botones 2x2
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildActivityButton(
                                  icon: Icons.videogame_asset_rounded,
                                  label: 'Mini-games',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MinigamesListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildActivityButton(
                                  icon: Icons.menu_book_rounded,
                                  label: 'Stories',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StoriesListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActivityButton(
                                  icon: Icons.help_outline_rounded,
                                  label: 'Quizzes',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const QuizzesListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildActivityButton(
                                  icon: Icons.favorite_rounded,
                                  label: 'Exercises',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ExercisesListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botones de navegación inferior
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botón de regreso
                        Material(
                          color: const Color(0xFF7A9FB8).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF5A7A8F),
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Botón LEVELS
                        Material(
                          color: const Color(0xFF7BA9D1),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              // Volver a la vista de niveles
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: const Text(
                                'LEVELS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un botón de actividad
  Widget _buildActivityButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF7BA9D1).withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Painter para el patrón de puntos decorativo
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8AACBF).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    const dotRadius = 3.0;
    const spacing = 20.0;

    // Crear patrón de puntos que se va desvaneciendo hacia abajo
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Calcular opacidad basada en la posición vertical
        final opacity = 1.0 - (y / size.height);
        paint.color = Color(0xFF8AACBF).withValues(alpha: 0.3 * opacity);

        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
