import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

/// Pantalla de bienvenida con diseño profesional
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onStart;

  const WelcomeScreen({
    super.key,
    required this.onStart,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
  with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _scaleController;
  late AnimationController _starController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de flotación suave
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Animación de escala (respiración)
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Animación de estrellas parpadeantes
    _starController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4F8), // Gris azulado muy claro (casi blanco)
              Color(0xFFF5F9FB), // Blanco azulado
              Color(0xFFFFFFFF), // Blanco puro
            ],
          ),
        ),
        child: Stack(
          children: [
            // Nubecitas decorativas de fondo (superior izquierda)
            Positioned(
              top: 60,
              left: 20,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value * 0.5),
                    child: Opacity(
                      opacity: 0.7,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 80,
                        height: 50,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Nubecita pequeña superior derecha
            Positioned(
              top: 40,
              right: 30,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatAnimation.value * 0.3),
                    child: Opacity(
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 60,
                        height: 40,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Estrellas decorativas
            Positioned(
              top: 80,
              right: 60,
              child: AnimatedBuilder(
                animation: _starController,
                builder: (context, child) {
                  final opacity = 0.45 + (0.25 * math.sin(_starController.value * math.pi * 2));
                  return Opacity(
                    opacity: opacity.clamp(0.2, 0.7),
                    child: SvgPicture.asset(
                      'assets/images/echomimi/stars.svg',
                      width: 50,
                      height: 50,
                    ),
                  );
                },
              ),
            ),

            // Nubecitas inferiores
            Positioned(
              bottom: 120,
              left: 10,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatAnimation.value * 0.4),
                    child: Opacity(
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 90,
                        height: 55,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 140,
              right: 20,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value * 0.6),
                    child: Opacity(
                      opacity: 0.7,
                      child: SvgPicture.asset(
                        'assets/images/echomimi/cloud.svg',
                        width: 70,
                        height: 45,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Contenido principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    // Título "Welcome!"
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3748),
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtítulo
                    Text(
                      'Start your journey with EchoMimi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748).withOpacity(0.6),
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // ECHOMIMI animado con SVG - con más movimiento
                    AnimatedBuilder(
                      animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_floatAnimation.value * 0.3, _floatAnimation.value * 1.5),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: SvgPicture.asset(
                              'assets/images/echomimi/level_1.svg',
                              width: 220,
                              height: 220,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // Logo ECHOMIMI con animación flotante
                    _buildAnimatedEchoMimiLogo(),

                    const Spacer(),

                    // Botón Start con animación
                    _buildStartButton(),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logo ECHOMIMI con animación flotante e iluminación
  Widget _buildAnimatedEchoMimiLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 2.5),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Halo de iluminación (brillo envolvente)
                Container(
                  width: 320,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withOpacity(0.25),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
                        blurRadius: 50,
                        offset: Offset.zero,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                ),
                // SVG del logo
                SvgPicture.asset(
                  'assets/images/echomimi/logo_bubble.svg',
                  width: 280,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Botón de inicio con animación hover
  Widget _buildStartButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF93C5FD),
                  Color(0xFF60A5FA),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF60A5FA).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onStart,
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: const Center(
                  child: Text(
                    'Start Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
