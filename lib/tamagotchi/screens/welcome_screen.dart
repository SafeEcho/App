import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Pantalla de bienvenida limpia y pastel para Safe Echo
/// Diseño minimalist con cloud character adorable y colores suaves
class WelcomeScreen extends StatefulWidget {
  final Function(String)? onModeSelected;

  const WelcomeScreen({
    super.key,
    this.onModeSelected,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _cloudFloatController;
  late AnimationController _cloudScaleController;
  late AnimationController _buttonScaleController;
  late Animation<double> _cloudFloatAnimation;
  late Animation<double> _cloudScaleAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de flotación suave para la nube principal
    _cloudFloatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _cloudFloatAnimation = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(
      parent: _cloudFloatController,
      curve: Curves.easeInOut,
    ));

    // Animación de respiración (escala suave)
    _cloudScaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _cloudScaleAnimation = Tween<double>(
      begin: 0.97,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _cloudScaleController,
      curve: Curves.easeInOut,
    ));

    // Animación del botón al cargar
    _buttonScaleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonScaleController, curve: Curves.elasticOut),
    );

    // Iniciar animación del botón
    _buttonScaleController.forward();
  }

  @override
  void dispose() {
    _cloudFloatController.dispose();
    _cloudScaleController.dispose();
    _buttonScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F4F8), // Gris claro pastel
              Color(0xFFF5F7FA), // Gris azulado muy claro
              Color(0xFFFAFBFC), // Casi blanco
            ],
          ),
        ),
        child: Stack(
          children: [
            // Nube decorativa superior izquierda (mitad visible)
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
              bottom: -30,
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

            // Contenido principal centrado
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Título "SAFE ECHO" en letras bubble
                                    _buildBubbleTitle(),

                                    const SizedBox(height: 20),

                                    // Texto "Welcome!"
                                    const Text(
                                      'Welcome!',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1A202C),
                                        letterSpacing: -1.5,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Subtítulo
                                    Text(
                                      'Start your journey of digital wellness',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF4A5568).withValues(alpha: 0.7),
                                        letterSpacing: 0.3,
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Cloud character adorable animado
                                    _buildAnimatedCloudCharacter(),

                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),

                            // Botones de selección de modo al fondo
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              child: _buildModeButtons(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el título "SAFE ECHO" usando el SVG logo_bubble
  Widget _buildBubbleTitle() {
    return SvgPicture.asset(
      'assets/images/echomimi/logo_bubble.svg',
      width: 280,
      height: 110,
    );
  }

  /// Construye el personaje nube adorable animado
  Widget _buildAnimatedCloudCharacter() {
    return AnimatedBuilder(
      animation: Listenable.merge([_cloudFloatAnimation, _cloudScaleAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _cloudFloatAnimation.value),
          child: Transform.scale(
            scale: _cloudScaleAnimation.value,
            child: _buildCloudCharacter(),
          ),
        );
      },
    );
  }

  /// Construye el personaje usando level_3.svg
  Widget _buildCloudCharacter() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        // Glow azul suave
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60A5FA).withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/images/echomimi/level_3.svg',
        width: 200,
        height: 200,
      ),
    );
  }


  /// Construye los 4 botones de selección de modo
  Widget _buildModeButtons() {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila 1: CHILDREN y TEENAGERS
          Row(
            children: [
              Expanded(
                child: _buildModeButton('CHILDREN', 'children'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton('TEENAGERS', 'teenagers'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fila 2: PARENTAL CONTROLS e INSTITUTIONAL ACCESS
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  'PARENTAL\nCONTROLS',
                  'parental',
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton(
                  'INSTITUTIONAL\nACCESS',
                  'institutional',
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye un botón individual de modo
  Widget _buildModeButton(String label, String mode, {double fontSize = 15}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF93C5FD), // Azul pastel claro
            Color(0xFF60A5FA), // Azul pastel
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60A5FA).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onModeSelected?.call(mode),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.15),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

