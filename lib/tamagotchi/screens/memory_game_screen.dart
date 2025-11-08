import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pet_model.dart';

/// Juego de memoria con símbolos de seguridad
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<String> _symbols = [
    '🔐', // Candado
    '🛡️', // Escudo
    '🔑', // Llave
    '👁️', // Ojo (privacidad)
    '🚫', // Prohibido
    '✅', // Correcto
  ];

  List<String> _cards = [];
  List<bool> _revealed = [];
  List<int> _matched = [];
  int? _firstCardIndex;
  int _moves = 0;
  int _matchesFound = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Crear pares de cartas
    _cards = [..._symbols, ..._symbols];
    _cards.shuffle(Random());

    _revealed = List.generate(_cards.length, (_) => false);
    _matched = [];
    _firstCardIndex = null;
    _moves = 0;
    _matchesFound = 0;
    _isChecking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildStats(),
              Expanded(
                child: _buildGameBoard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.blue),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '🧠 Memoria de Seguridad',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                '🎯',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                'Movimientos: $_moves',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                '✨',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                'Parejas: $_matchesFound/${_symbols.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return _buildCard(index);
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    final isRevealed = _revealed[index] || _matched.contains(index);
    final isMatched = _matched.contains(index);

    return GestureDetector(
      onTap: () => _onCardTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isMatched
                ? [Colors.green, Colors.green.shade300]
                : isRevealed
                    ? [Colors.white, Colors.blue.shade50]
                    : [Colors.blue, Colors.blue.shade700],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isMatched
                  ? Colors.green.withOpacity(0.5)
                  : Colors.blue.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isRevealed ? _cards[index] : '?',
            style: TextStyle(
              fontSize: 48,
              color: isRevealed ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _onCardTapped(int index) {
    if (_isChecking ||
        _revealed[index] ||
        _matched.contains(index) ||
        index == _firstCardIndex) {
      return;
    }

    setState(() {
      _revealed[index] = true;

      if (_firstCardIndex == null) {
        // Primera carta seleccionada
        _firstCardIndex = index;
      } else {
        // Segunda carta seleccionada
        _moves++;
        _isChecking = true;

        final firstCard = _cards[_firstCardIndex!];
        final secondCard = _cards[index];

        if (firstCard == secondCard) {
          // ¡Par encontrado!
          _matched.add(_firstCardIndex!);
          _matched.add(index);
          _matchesFound++;
          _firstCardIndex = null;
          _isChecking = false;

          // Verificar si ganó
          if (_matchesFound == _symbols.length) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _showWinDialog();
            });
          }
        } else {
          // No coinciden, ocultar después de un momento
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _revealed[_firstCardIndex!] = false;
                _revealed[index] = false;
                _firstCardIndex = null;
                _isChecking = false;
              });
            }
          });
        }
      }
    });
  }

  void _showWinDialog() {
    final pet = context.read<PetModel>();
    pet.winMinigame(experienceGain: 20);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.purple,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Ganaste!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Completaste el juego en $_moves movimientos',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '+20 Experiencia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _initializeGame();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Jugar de Nuevo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar diálogo
                        Navigator.pop(context); // Volver a mini-juegos
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
