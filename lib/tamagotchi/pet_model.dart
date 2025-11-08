import 'package:flutter/foundation.dart';
import 'persistence/pet_persistence.dart';

/// Estados de ánimo de la mascota
enum PetMood {
  happy,
  sad,
  sleepy,
  excited,
  sick,
  learning,
}

/// Modelo de la mascota Tamagochi
class PetModel extends ChangeNotifier {
  final PetPersistence _persistence;

  PetModel(this._persistence);
  // Atributos principales (0-100)
  double _hunger = 50.0;
  double _happiness = 80.0;
  double _energy = 70.0;
  double _knowledge = 0.0; // Conocimiento sobre seguridad digital
  double _health = 100.0;

  // Nivel y experiencia
  int _level = 1;
  int _experience = 0;
  int _experienceToNextLevel = 100;

  // Nombre de la mascota
  String _name = 'EchoMimi';

  // Estado actual
  PetMood _mood = PetMood.happy;
  bool _isSleeping = false;

  // Lecciones completadas
  Set<String> _completedLessons = {};

  // Logros desbloqueados
  Set<String> _unlockedAchievements = {};

  // Última actualización (para calcular degradación con el tiempo)
  DateTime _lastUpdate = DateTime.now();

  // Getters
  double get hunger => _hunger;
  double get happiness => _happiness;
  double get energy => _energy;
  double get knowledge => _knowledge;
  double get health => _health;
  int get level => _level;
  int get experience => _experience;
  int get experienceToNextLevel => _experienceToNextLevel;
  String get name => _name;
  PetMood get mood => _mood;
  bool get isSleeping => _isSleeping;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get unlockedAchievements => _unlockedAchievements;

  /// Progreso al siguiente nivel (0.0 - 1.0)
  double get levelProgress => _experience / _experienceToNextLevel;

  /// Estado general de la mascota (0.0 - 1.0)
  double get overallWellness =>
      (_happiness + _energy + _health + (100 - _hunger)) / 400;

  /// Carga datos guardados
                  Future<void> loadData() async {
    final data = await _persistence.loadPetData();
    if (data != null) {
      fromJson(data);
    }
  }

  /// Guarda datos automáticamente
  Future<void> _saveData() async {
    await _persistence.savePetData(toJson());
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    _saveData(); // Guardar automáticamente cada vez que hay cambios
  }

  /// Actualiza el estado de la mascota basado en el tiempo transcurrido
  void updateWithTime() {
    final now = DateTime.now();
    final minutesPassed = now.difference(_lastUpdate).inMinutes;

    if (minutesPassed > 0) {
      // Degradación con el tiempo (cada minuto)
      _hunger = (_hunger + minutesPassed * 0.5).clamp(0.0, 100.0);
      _energy = (_energy - minutesPassed * 0.3).clamp(0.0, 100.0);
      _happiness = (_happiness - minutesPassed * 0.2).clamp(0.0, 100.0);

      // Si el hambre es muy alta o la energía muy baja, afecta la salud
      if (_hunger > 80 || _energy < 20) {
        _health = (_health - minutesPassed * 0.1).clamp(0.0, 100.0);
      } else if (_health < 100) {
        // Regeneración lenta de salud
        _health = (_health + minutesPassed * 0.05).clamp(0.0, 100.0);
      }

      _lastUpdate = now;
      _updateMood();
      notifyListeners();
    }
  }

  /// Alimenta a la mascota
  void feed({int amount = 20}) {
    _hunger = (_hunger - amount).clamp(0.0, 100.0);
    _happiness = (_happiness + 5).clamp(0.0, 100.0);
    _addExperience(5);
    _updateMood();
    notifyListeners();
  }

  /// Juega con la mascota
  void play() {
    if (_energy < 20) {
      // Muy cansada para jugar
      return;
    }

    _happiness = (_happiness + 15).clamp(0.0, 100.0);
    _energy = (_energy - 10).clamp(0.0, 100.0);
    _hunger = (_hunger + 5).clamp(0.0, 100.0);
    _addExperience(10);
    _updateMood();
    notifyListeners();
  }

  /// Pone a dormir a la mascota
  void sleep() {
    _isSleeping = true;
    _mood = PetMood.sleepy;
    notifyListeners();
  }

  /// Despierta a la mascota
  void wakeUp() {
    _isSleeping = false;
    _energy = 100.0;
    _happiness = (_happiness + 10).clamp(0.0, 100.0);
    _updateMood();
    notifyListeners();
  }

  /// Completa una lección de seguridad digital
  void completeLesson(String lessonId, {int knowledgeGain = 10}) {
    if (!_completedLessons.contains(lessonId)) {
      _completedLessons.add(lessonId);
      _knowledge = (_knowledge + knowledgeGain).clamp(0.0, 100.0);
      _happiness = (_happiness + 20).clamp(0.0, 100.0);
      _addExperience(25);
      _mood = PetMood.learning;

      // Verificar logros
      _checkAchievements();

      notifyListeners();
    }
  }

  /// Gana un mini-juego
  void winMinigame({int experienceGain = 15}) {
    _happiness = (_happiness + 10).clamp(0.0, 100.0);
    _energy = (_energy - 5).clamp(0.0, 100.0);
    _addExperience(experienceGain);
    _mood = PetMood.excited;
    notifyListeners();
  }

  /// Agrega experiencia y verifica si sube de nivel
  void _addExperience(int amount) {
    _experience += amount;

    // Subir de nivel
    while (_experience >= _experienceToNextLevel) {
      _experience -= _experienceToNextLevel;
      _level++;
      _experienceToNextLevel = (_experienceToNextLevel * 1.5).round();
      _mood = PetMood.excited;

      // Recompensas por subir de nivel
      _health = 100.0;
      _happiness = 100.0;
    }
  }

  /// Actualiza el estado de ánimo según las estadísticas
  void _updateMood() {
    if (_isSleeping) {
      _mood = PetMood.sleepy;
    } else if (_health < 30) {
      _mood = PetMood.sick;
    } else if (_happiness > 70 && _energy > 50) {
      _mood = PetMood.happy;
    } else if (_happiness < 30 || _energy < 20) {
      _mood = PetMood.sad;
    } else if (_knowledge > 50) {
      _mood = PetMood.learning;
    } else {
      _mood = PetMood.happy;
    }
  }

  /// Verifica y desbloquea logros
  void _checkAchievements() {
    if (_completedLessons.length >= 3 &&
        !_unlockedAchievements.contains('first_steps')) {
      _unlockedAchievements.add('first_steps');
    }

    if (_completedLessons.length >= 10 &&
        !_unlockedAchievements.contains('cyber_expert')) {
      _unlockedAchievements.add('cyber_expert');
    }

    if (_level >= 5 && !_unlockedAchievements.contains('level_master')) {
      _unlockedAchievements.add('level_master');
    }

    if (_knowledge >= 100 &&
        !_unlockedAchievements.contains('security_champion')) {
      _unlockedAchievements.add('security_champion');
    }
  }

  /// Cambia el nombre de la mascota
  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }

  /// Cura a la mascota (después de atenderla cuando está enferma)
  void heal() {
    _health = 100.0;
    _happiness = (_happiness + 10).clamp(0.0, 100.0);
    _updateMood();
    notifyListeners();
  }

  /// Resetea la mascota (para testing o nuevo juego)
  void reset() {
    _hunger = 50.0;
    _happiness = 80.0;
    _energy = 70.0;
    _knowledge = 0.0;
    _health = 100.0;
    _level = 1;
    _experience = 0;
    _experienceToNextLevel = 100;
    _name = 'EchoMimi';
    _mood = PetMood.happy;
    _isSleeping = false;
    _completedLessons.clear();
    _unlockedAchievements.clear();
    _lastUpdate = DateTime.now();
    notifyListeners();
  }

  /// Serializa el modelo a JSON para persistencia
  Map<String, dynamic> toJson() {
    return {
      'hunger': _hunger,
      'happiness': _happiness,
      'energy': _energy,
      'knowledge': _knowledge,
      'health': _health,
      'level': _level,
      'experience': _experience,
      'experienceToNextLevel': _experienceToNextLevel,
      'name': _name,
      'mood': _mood.index,
      'isSleeping': _isSleeping,
      'completedLessons': _completedLessons.toList(),
      'unlockedAchievements': _unlockedAchievements.toList(),
      'lastUpdate': _lastUpdate.toIso8601String(),
    };
  }

  /// Deserializa el modelo desde JSON
  void fromJson(Map<String, dynamic> json) {
    _hunger = (json['hunger'] as num?)?.toDouble() ?? 50.0;
    _happiness = (json['happiness'] as num?)?.toDouble() ?? 80.0;
    _energy = (json['energy'] as num?)?.toDouble() ?? 70.0;
    _knowledge = (json['knowledge'] as num?)?.toDouble() ?? 0.0;
    _health = (json['health'] as num?)?.toDouble() ?? 100.0;
    _level = (json['level'] as num?)?.toInt() ?? 1;
    _experience = (json['experience'] as num?)?.toInt() ?? 0;
    _experienceToNextLevel = (json['experienceToNextLevel'] as num?)?.toInt() ?? 100;
    _name = (json['name'] as String?) ?? 'EchoMimi';
    _mood = PetMood.values[(json['mood'] as int?) ?? 0];
    _isSleeping = (json['isSleeping'] as bool?) ?? false;
    _completedLessons = Set<String>.from((json['completedLessons'] as List?) ?? []);
    _unlockedAchievements =
        Set<String>.from((json['unlockedAchievements'] as List?) ?? []);
    _lastUpdate = DateTime.parse(
      (json['lastUpdate'] as String?) ?? DateTime.now().toIso8601String(),
    );
    notifyListeners();
  }
}
