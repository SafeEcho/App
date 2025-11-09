import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math';

/// Pantalla del juego "Catch the Impostor"
class CatchTheImpostorScreen extends StatefulWidget {
  const CatchTheImpostorScreen({super.key});

  @override
  State<CatchTheImpostorScreen> createState() => _CatchTheImpostorScreenState();
}

class _CatchTheImpostorScreenState extends State<CatchTheImpostorScreen> {
  bool _showInstructions = true;

  @override
  Widget build(BuildContext context) {
    if (_showInstructions) {
      return _buildInstructions();
    }
    return const CatchTheImpostorGame();
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
                    'Catch the\nImpostor',
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
                            'Pay close attention when each character pops up: you will have to catch the impostors as quickly as possible, but be careful of hurting your buddy!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4A5568),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Personajes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  // Buddy (personaje bueno) - usar icono de persona
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7BA9D1),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7BA9D1).withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Buddy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A202C),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  // Impostor - usar icono de advertencia
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A202C),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1A202C).withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person_off,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Impostor',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A202C),
                                    ),
                                  ),
                                ],
                              ),
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
}

/// Juego principal de Catch the Impostor
class CatchTheImpostorGame extends StatefulWidget {
  const CatchTheImpostorGame({super.key});

  @override
  State<CatchTheImpostorGame> createState() => _CatchTheImpostorGameState();
}

class _CatchTheImpostorGameState extends State<CatchTheImpostorGame> {
  int _score = 0;
  final List<bool> _isImpostor = List.generate(6, (_) => false);
  Timer? _gameTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateCharacters();
  }

  void _generateCharacters() {
    setState(() {
      for (int i = 0; i < 6; i++) {
        _isImpostor[i] = _random.nextBool();
      }
    });
  }

  void _onCharacterTap(int index) {
    if (_isImpostor[index]) {
      // Atrapaste al impostor!
      setState(() {
        _score++;
      });
    } else {
      // Era un buddy, penalización
      setState(() {
        _score = (_score - 1).clamp(0, 999);
      });
    }
    _generateCharacters();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
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
                    'Catch the\nImpostor',
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

                  // Grid de personajes
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                            // Score
                            Text(
                              'Score: $_score',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A202C),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Grid 2x3 de personajes
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => _onCharacterTap(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _isImpostor[index]
                                            ? const Color(0xFF1A202C)
                                            : const Color(0xFF7BA9D1),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_isImpostor[index]
                                                    ? const Color(0xFF1A202C)
                                                    : const Color(0xFF7BA9D1))
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _isImpostor[index]
                                              ? Icons.person_off
                                              : Icons.person,
                                          size: 40,
                                          color: Colors.white,
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
                    ),
                  ),

                  const SizedBox(height: 20),

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
