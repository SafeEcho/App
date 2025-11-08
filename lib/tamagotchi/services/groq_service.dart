import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para interactuar con la API de GROQ
class GroqService {
  final String apiKey;
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  GroqService(this.apiKey);

  /// Envía un mensaje y obtiene respuesta del chatbot
  Future<String> sendMessage(String message, {String petName = 'ECHOMIMI'}) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': '''Eres $petName, una mascota virtual kawaii y adorable que enseña seguridad digital a niños y adolescentes.
Características de tu personalidad:
- Eres muy tierno, amigable y usas emojis frecuentemente 💜✨
- Hablas en español de manera simple y clara
- Explicas conceptos de ciberseguridad de forma divertida
- Eres paciente y motivador
- Te encanta jugar y aprender
- Usas ejemplos del día a día para enseñar
- Respondes de manera breve (máximo 3-4 oraciones)
- A veces haces sonidos kawaii como "ñam ñam" o "kyaa~"
- Te preocupas por el bienestar de tu dueño

Temas que enseñas:
- Contraseñas seguras
- Privacidad en redes sociales
- Phishing y estafas
- Comportamiento en línea
- Protección de datos personales''',
            },
            {
              'role': 'user',
              'content': message,
            },
          ],
          'temperature': 0.8,
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Error al comunicarse con GROQ: ${response.statusCode}');
      }
    } catch (e) {
      return '¡Ups! 😅 Parece que tengo un problemita para responderte. ¿Podrías intentarlo de nuevo? 💜';
    }
  }
}
