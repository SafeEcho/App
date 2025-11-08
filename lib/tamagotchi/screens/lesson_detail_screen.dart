import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pet_model.dart';
import '../security_lessons.dart';

/// Pantalla de detalle de una lección
class LessonDetailScreen extends StatefulWidget {
  final SecurityLesson lesson;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentStep = 0; // 0 = lectura, 1+ = preguntas del quiz
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _correctAnswers = 0;

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetModel>();
    final isCompleted = pet.completedLessons.contains(widget.lesson.id);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.lesson.color.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isCompleted),
              Expanded(
                child: _currentStep == 0
                    ? _buildLessonContent()
                    : _buildQuizContent(),
              ),
              _buildNavigationButtons(pet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isCompleted) {
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
                    color: widget.lesson.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back, color: widget.lesson.color),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.lesson.emoji} ${widget.lesson.title}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.lesson.color,
                  ),
                ),
                if (isCompleted)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '✓ Completada',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descripción
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.lesson.color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '📝 Puntos Clave:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.lesson.keyPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.lesson.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Tarjeta de motivación
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.lesson.color.withOpacity(0.7),
                  widget.lesson.color.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Text('💪', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '¡Ahora que sabes esto, eres más seguro en internet!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    final questionIndex = _currentStep - 1;
    final question = widget.lesson.quiz[questionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progreso del quiz
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Text(
                  '🎯 Pregunta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$questionIndex/${widget.lesson.quiz.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.lesson.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Pregunta
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.lesson.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.lesson.color,
                width: 3,
              ),
            ),
            child: Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Opciones
          ...List.generate(
            question.options.length,
            (index) => _buildOptionButton(question, index),
          ),
          // Explicación
          if (_showExplanation) ...[
            const SizedBox(height: 24),
            _buildExplanation(question),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionButton(QuizQuestion question, int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = question.correctAnswer == index;
    final showResult = _showExplanation;

    Color getColor() {
      if (!showResult) {
        return isSelected ? widget.lesson.color : Colors.grey.shade300;
      }
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
      return Colors.grey.shade300;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: _showExplanation
            ? null
            : () {
                setState(() {
                  _selectedAnswer = index;
                });
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: getColor().withOpacity(0.5),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: getColor().withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: getColor(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: showResult || isSelected
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
              if (showResult && isCorrect)
                const Icon(Icons.check_circle, color: Colors.white, size: 28),
              if (showResult && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(QuizQuestion question) {
    final isCorrect = _selectedAnswer == question.correctAnswer;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isCorrect ? '🎉' : '💡',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCorrect ? '¡Correcto!' : '¡Aprendamos juntos!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.explanation,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(PetModel pet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                    _selectedAnswer = null;
                    _showExplanation = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Anterior',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _getNextButtonAction(pet),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.lesson.color,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                _getNextButtonText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    if (_currentStep == 0) return '¡Tomar Quiz! 📝';
    if (_showExplanation) {
      if (_currentStep < widget.lesson.quiz.length) {
        return 'Siguiente Pregunta ➡️';
      } else {
        return '¡Completar Lección! 🎉';
      }
    }
    return 'Verificar Respuesta ✓';
  }

  VoidCallback? _getNextButtonAction(PetModel pet) {
    if (_currentStep == 0) {
      return () {
        setState(() {
          _currentStep = 1;
        });
      };
    }

    if (!_showExplanation) {
      if (_selectedAnswer == null) return null;
      return () {
        final question = widget.lesson.quiz[_currentStep - 1];
        if (_selectedAnswer == question.correctAnswer) {
          _correctAnswers++;
        }
        setState(() {
          _showExplanation = true;
        });
      };
    }

    return () {
      if (_currentStep < widget.lesson.quiz.length) {
        setState(() {
          _currentStep++;
          _selectedAnswer = null;
          _showExplanation = false;
        });
      } else {
        // Completar la lección
        pet.completeLesson(
          widget.lesson.id,
          knowledgeGain: widget.lesson.knowledgeValue,
        );

        // Mostrar diálogo de felicitaciones
        _showCompletionDialog(pet);
      }
    };
  }

  void _showCompletionDialog(PetModel pet) {
    final percentage =
        (_correctAnswers / widget.lesson.quiz.length * 100).round();

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
                widget.lesson.color.withOpacity(0.8),
                widget.lesson.color,
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
                '¡Lección Completada!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
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
                      'Calificación: $percentage%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.lesson.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_correctAnswers/${widget.lesson.quiz.length} respuestas correctas',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '+${widget.lesson.knowledgeValue} Conocimiento',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pop(context); // Volver a la lista de lecciones
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '¡Genial! 👍',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.lesson.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
