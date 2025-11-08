import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Interfaz para la persistencia del estado de la mascota
abstract class PetPersistence {
  Future<Map<String, dynamic>?> loadPetData();
  Future<void> savePetData(Map<String, dynamic> data);
  Future<void> clearPetData();
}

/// Implementación usando SharedPreferences
class LocalStoragePetPersistence implements PetPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  static const String _petDataKey = 'pet_data';

  @override
  Future<Map<String, dynamic>?> loadPetData() async {
    final prefs = await instanceFuture;
    final jsonString = prefs.getString(_petDataKey);

    if (jsonString == null) {
      return null;
    }

    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Si hay error al decodificar, retornar null
      return null;
    }
  }

  @override
  Future<void> savePetData(Map<String, dynamic> data) async {
    final prefs = await instanceFuture;
    final jsonString = json.encode(data);
    await prefs.setString(_petDataKey, jsonString);
  }

  @override
  Future<void> clearPetData() async {
    final prefs = await instanceFuture;
    await prefs.remove(_petDataKey);
  }
}

/// Implementación en memoria (para testing)
class MemoryPetPersistence implements PetPersistence {
  Map<String, dynamic>? _data;

  @override
  Future<Map<String, dynamic>?> loadPetData() async {
    return _data;
  }

  @override
  Future<void> savePetData(Map<String, dynamic> data) async {
    _data = data;
  }

  @override
  Future<void> clearPetData() async {
    _data = null;
  }
}
