import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Servicio para text-to-speech con ElevenLabs
class ElevenLabsService {
  final String apiKey;
  final String voiceId;
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';

  ElevenLabsService(this.apiKey, this.voiceId);

  /// Convierte texto a audio y devuelve la ruta del archivo
  Future<String?> textToSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/text-to-speech/$voiceId'),
        headers: {
          'Content-Type': 'application/json',
          'xi-api-key': apiKey,
        },
        body: jsonEncode({
          'text': text,
          'model_id': 'eleven_multilingual_v2',
          'voice_settings': {
            'stability': 0.5,
            'similarity_boost': 0.75,
            'style': 0.5,
            'use_speaker_boost': true,
          },
        }),
      );

      if (response.statusCode == 200) {
        // Guardar el audio en un archivo temporal
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/echomimi_speech_${DateTime.now().millisecondsSinceEpoch}.mp3';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print('Error ElevenLabs: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en textToSpeech: $e');
      return null;
    }
  }
}
