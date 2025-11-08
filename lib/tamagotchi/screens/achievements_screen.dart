import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pet_model.dart';

/// Modelo de logro
class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final Color color;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

/// Pantalla de logros y achievements
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const List<Achievement> _allAchievements = [
    Achievement(
      id: 'first_steps',
      title: 'Primeros Pasos',
      description: 'Completa 3 lecciones de seguridad',
      emoji: '🎯',
      color: Colors.blue,
    ),
    Achievement(
      id: 'cyber_expert',
      title: 'Experto Cyber',
      description: 'Completa 10 lecciones de seguridad',
      emoji: '🏆',
      color: Colors.amber,
    ),
    Achievement(
      id: 'level_master',
      title: 'Maestro de Niveles',
      description: 'Alcanza el nivel 5',
      emoji: '⭐',
      color: Colors.purple,
    ),
    Achievement(
      id: 'security_champion',
      title: 'Campeón de Seguridad',
      description: 'Alcanza 100 puntos de conocimiento',
      emoji: '🛡️',
      color: Colors.green,
    ),
    Achievement(
      id: 'dedicated_friend',
      title: 'Amigo Dedicado',
      description: 'Cuida a tu mascota por 7 días seguidos',
      emoji: '❤️',
      color: Colors.red,
    ),
    Achievement(
      id: 'gamer',
      title: 'Jugador Profesional',
      description: 'Completa 20 mini-juegos',
      emoji: '🎮',
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.shade100,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildStats(context),
              Expanded(
                child: _buildAchievementsList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.amber),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '🏆 Logros y Trofeos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final pet = context.watch<PetModel>();
    final unlockedCount = pet.unlockedAchievements.length;
    final totalCount = _allAchievements.length;
    final progress = unlockedCount / totalCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
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
              const Text(
                '📊 Progreso General',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$unlockedCount/$totalCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context) {
    final pet = context.watch<PetModel>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allAchievements.length,
      itemBuilder: (context, index) {
        final achievement = _allAchievements[index];
        final isUnlocked = pet.unlockedAchievements.contains(achievement.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAchievementCard(achievement, isUnlocked),
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUnlocked
              ? [
                  achievement.color,
                  achievement.color.withOpacity(0.7),
                ]
              : [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isUnlocked
                ? achievement.color.withOpacity(0.4)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji/Icono
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isUnlocked ? achievement.emoji : '🔒',
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUnlocked ? achievement.title : '???',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.white : Colors.grey.shade600,
                    shadows: isUnlocked
                        ? [
                            const Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isUnlocked ? achievement.description : 'Logro bloqueado',
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked ? Colors.white : Colors.grey.shade500,
                    shadows: isUnlocked
                        ? [
                            const Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
          // Checkmark si está desbloqueado
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: achievement.color,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
