import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pet_model.dart';
import '../widgets/action_button.dart';
import 'achievements_screen.dart';
import 'echo_panel_screen.dart';
import 'chat_screen.dart';

/// Pantalla principal del Tamagochi
class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  State<PetHomeScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de flotación para la mascota
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Actualizar el estado de la mascota con el tiempo
    Future.delayed(Duration.zero, () {
      context.read<PetModel>().updateWithTime();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF9575CD),
        icon: const Icon(Icons.chat_bubble, color: Colors.white),
        label: const Text(
          'Hablar con Echomimi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD), // Azul muy claro
              Color(0xFFBBDEFB), // Azul celeste claro
              Color(0xFF90CAF9), // Azul celeste suave
              Color(0xFFB3E5FC), // Cyan muy claro
            ],
          ),
        ),
        child: Stack(
          children: [
            // Nubecitas decorativas flotantes
            _buildDecorativeClouds(),

            // Contenido principal
            SafeArea(
              child: Consumer<PetModel>(
                builder: (context, pet, child) {
                  return Column(
                    children: [
                      // Header con nombre y nivel
                      _buildHeader(pet),

                      // Mascota virtual (centro de la pantalla) - Nivel 1 SVG animado
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: SvgPicture.asset(
                                  'assets/images/echomimi/level_1.svg',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de acción
                      _buildActionsSection(pet),

                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeClouds() {
    return Stack(
      children: [
        // Nubecita pequeña superior izquierda
        Positioned(
          top: 80,
          left: 20,
          child: AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_floatAnimation.value * 0.5),
                child: Opacity(
                  opacity: 0.4,
                  child: CustomPaint(
                    size: const Size(50, 30),
                    painter: _SimpleCloudPainter(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Nubecita superior derecha
        Positioned(
          top: 120,
          right: 30,
          child: AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.3),
                child: Opacity(
                  opacity: 0.35,
                  child: CustomPaint(
                    size: const Size(60, 36),
                    painter: _SimpleCloudPainter(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(PetModel pet) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nombre y nivel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0277BD), // Azul profundo suave
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Color(0xFF81D4FA),
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EchoPanelScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FC3F7).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Nivel ${pet.level}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botón de logros
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF81D4FA).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.emoji_events, color: Color(0xFFFFB300)),
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AchievementsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(PetModel pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              label: 'ALIMENTAR',
              emoji: '🍎',
              color: const Color(0xFF66BB6A), // Verde suave
              onPressed: pet.isSleeping
                  ? null
                  : () {
                      pet.feed();
                      _showFeedback('¡Ñam ñam! 😋');
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              label: pet.isSleeping ? 'DESPERTAR' : 'DORMIR',
              emoji: '😴',
              color: const Color(0xFF9575CD), // Púrpura suave
              onPressed: () {
                if (pet.isSleeping) {
                  pet.wakeUp();
                  _showFeedback('¡Buenos días! ☀️');
                } else {
                  pet.sleep();
                  _showFeedback('Buenas noches... 🌙');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF0277BD),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 6,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Painter simple para nubecitas decorativas
class _SimpleCloudPainter extends CustomPainter {
  final Color color;

  _SimpleCloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Nube simple con 3 círculos
    canvas.drawCircle(
      center,
      size.width * 0.25,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.2, center.dy),
      size.width * 0.2,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.2, center.dy),
      size.width * 0.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SimpleCloudPainter oldDelegate) => false;
}
