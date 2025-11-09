import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'echo_panel_screen.dart';

/// Pantalla de detalle de un nivel específico con tareas
class LevelDetailScreen extends StatefulWidget {
  final int level;
  final String levelName;

  const LevelDetailScreen({
    super.key,
    required this.level,
    required this.levelName,
  });

  @override
  State<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends State<LevelDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  // Estado de las tareas (checkboxes)
  final Map<int, List<bool>> _taskStates = {
    1: [false, false, false, false],
    2: [false, false, false, false],
    3: [false, false, false, false],
    4: [false, false, false, false],
    5: [false, false, false, false],
    6: [false, false, false, false],
  };

  // Tareas para cada nivel
  final Map<int, List<String>> _levelTasks = {
    1: [
      'Learn basic internet safety',
      'Meet your EchoMimi friend',
      'Complete introduction quiz',
      'Set up your safe space',
    ],
    2: [
      'Learn how to block and report users',
      'Read the interactive story "Searching aid"',
      'Take the quiz "What would I do?"',
      'Create your personal Safety Plan',
    ],
    3: [
      'Understand privacy settings',
      'Complete "Digital footprint" story',
      'Practice identifying safe content',
      'Update your safety plan',
    ],
    4: [
      'Learn about online bullying',
      'Read "Standing up" story',
      'Complete empathy quiz',
      'Help a friend scenario',
    ],
    5: [
      'Master digital citizenship',
      'Complete "Being a hero" story',
      'Advanced safety quiz',
      'Create community guidelines',
    ],
    6: [
      'Become a safety expert',
      'Read all bonus stories',
      'Final mastery quiz',
      'Earn your EchoMimi Master badge',
    ],
  };

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _levelTasks[widget.level] ?? [];
    final taskStates = _taskStates[widget.level] ?? [];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Patrón de puntos decorativo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _DotPatternPainter(),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header con botones
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Botón de regreso
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF7BA9D1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          // Botón MENU
                          GestureDetector(
                            onTap: () {
                              // Navegar al EchoPanel con panel de actividades
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EchoPanelScreen(
                                    showActivitiesPanel: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7BA9D1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'MENU',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Título del nivel
                    Text(
                      widget.levelName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF263238),
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Personaje EchoMimi animado
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -10 * _floatController.value),
                          child: SvgPicture.asset(
                            'assets/images/echomimi/level_${widget.level}.svg',
                            width: 120,
                            height: 120,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Plataforma azul debajo del personaje
                    Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF5A9FD4).withValues(alpha: 0.8),
                            const Color(0xFF5A9FD4).withValues(alpha: 0.5),
                            const Color(0xFF5A9FD4).withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Label "Level X"
                    Text(
                      'Level ${widget.level}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64B5F6),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lista de tareas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: List.generate(
                          tasks.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Punto bullet
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, right: 8),
                                  child: Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: Color(0xFF64B5F6),
                                  ),
                                ),

                                // Texto de la tarea
                                Expanded(
                                  child: Text(
                                    tasks[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64B5F6),
                                      height: 1.4,
                                    ),
                                  ),
                                ),

                                // Checkbox
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      taskStates[index] = !taskStates[index];
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFBDBDBD),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      color: taskStates[index]
                                          ? const Color(0xFF64B5F6)
                                          : Colors.white,
                                    ),
                                    child: taskStates[index]
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
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
