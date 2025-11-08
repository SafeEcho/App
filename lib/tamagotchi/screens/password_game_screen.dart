import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pet_model.dart';

/// Juego de detective de contraseñas
class PasswordGameScreen extends StatefulWidget {
  const PasswordGameScreen({super.key});

  @override
  State<PasswordGameScreen> createState() => _PasswordGameScreenState();
}

class _PasswordGameScreenState extends State<PasswordGameScreen> {
  final List<Map<String, dynamic>> _passwords = [
    {'password': 'juan123', 'secure': false, 'reason': 'Muy corta y usa nombre'},
    {'password': 'P@ssw0rd!2024', 'secure': true, 'reason': 'Larga, con símbolos y números'},
    {'password': '12345678', 'secure': false, 'reason': 'Secuencia de números simple'},
    {'password': 'password', 'secure': false, 'reason': 'Palabra común, muy fácil de adivinar'},
    {'password': 'M1P3rr0F3l1z!', 'secure': true, 'reason': 'Mezcla letras, números y símbolos'},
    {'password': 'qwerty', 'secure': false, 'reason': 'Secuencia de teclado muy común'},
    {'password': 'S3gur@_2024!', 'secure': true, 'reason': 'Combina mayúsculas, números y símbolos'},
    {'password': 'abc123', 'secure': false, 'reason': 'Muy simple y predecible'},
    {'password': 'C@s@Azul#789', 'secure': true, 'reason': 'Larga y con buena mezcla de caracteres'},
    {'password': 'Maria2010', 'secure': false, 'reason': 'Usa nombre y posible fecha de nacimiento'},
  ];

  int _currentPasswordIndex = 0;
  int _score = 0;
  int _questionsAnswered = 0;
  bool _showFeedback = false;
  bool? _userAnswer;
  final int _totalQuestions = 5;

  @override
  void initState() {
    super.initState();
    _passwords.shuffle(Random());
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
              Colors.purple.shade100,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgress(),
              Expanded(
                child: _questionsAnswered < _totalQuestions
                    ? _buildQuestionCard()
                    : _buildFinalScore(),
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
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.purple),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '🔐 Detective de Contraseñas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta ${_questionsAnswered + 1}/$_totalQuestions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Text(
                '⭐ Puntos: $_score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _questionsAnswered / _totalQuestions,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final currentPassword = _passwords[_currentPasswordIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            '¿Esta contraseña es SEGURA?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Contraseña a evaluar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.purple,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '🔑',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentPassword['password'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Botones de respuesta
          if (!_showFeedback) ...[
            Row(
              children: [
                Expanded(
                  child: _buildAnswerButton(
                    label: 'SÍ, ES SEGURA',
                    emoji: '✅',
                    color: Colors.green,
                    isSecure: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnswerButton(
                    label: 'NO ES SEGURA',
                    emoji: '❌',
                    color: Colors.red,
                    isSecure: false,
                  ),
                ),
              ],
            ),
          ],
          // Feedback
          if (_showFeedback) ...[
            const SizedBox(height: 24),
            _buildFeedback(currentPassword),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerButton({
    required String label,
    required String emoji,
    required Color color,
    required bool isSecure,
  }) {
    return GestureDetector(
      onTap: () => _checkAnswer(isSecure),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(Map<String, dynamic> password) {
    final isCorrect = _userAnswer == password['secure'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCorrect ? Colors.green : Colors.orange,
              width: 3,
            ),
          ),
          child: Column(
            children: [
              Text(
                isCorrect ? '🎉' : '💡',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                isCorrect ? '¡Correcto!' : '¡Ups! Veamos por qué...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Esta contraseña ${(password['secure'] as bool) ? 'SÍ' : 'NO'} es segura.',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                password['reason'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _nextQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            _questionsAnswered < _totalQuestions - 1
                ? 'Siguiente Contraseña →'
                : 'Ver Resultado Final',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalScore() {
    final percentage = (_score / _totalQuestions * 100).round();
    String message;
    String emoji;

    if (percentage >= 80) {
      message = '¡Eres un experto en contraseñas!';
      emoji = '🏆';
    } else if (percentage >= 60) {
      message = '¡Muy bien! Sigues aprendiendo.';
      emoji = '⭐';
    } else {
      message = '¡Sigue practicando! Cada vez serás mejor.';
      emoji = '💪';
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple,
              Colors.pink,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Juego Completado!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Puntuación: $percentage%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_score/$_totalQuestions respuestas correctas',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '+${(_score * 5)} Experiencia',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
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
                      setState(() {
                        _currentPasswordIndex = 0;
                        _score = 0;
                        _questionsAnswered = 0;
                        _showFeedback = false;
                        _userAnswer = null;
                        _passwords.shuffle(Random());
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
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final pet = context.read<PetModel>();
                      pet.winMinigame(experienceGain: _score * 5);
                      Navigator.pop(context);
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
    );
  }

  void _checkAnswer(bool answer) {
    setState(() {
      _userAnswer = answer;
      _showFeedback = true;

      final currentPassword = _passwords[_currentPasswordIndex];
      if (answer == currentPassword['secure']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionsAnswered++;
      _currentPasswordIndex++;
      _showFeedback = false;
      _userAnswer = null;
    });
  }
}
