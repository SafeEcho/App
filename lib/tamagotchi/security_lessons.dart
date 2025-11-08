import 'package:flutter/material.dart';

/// Categorías de lecciones
enum LessonCategory {
  passwords,
  privacy,
  social,
  strangers,
  cyberbullying,
  screenTime,
}

/// Modelo de una lección de seguridad digital
class SecurityLesson {
  final String id;
  final String title;
  final String emoji;
  final LessonCategory category;
  final String description;
  final List<String> keyPoints;
  final List<QuizQuestion> quiz;
  final Color color;
  final int knowledgeValue;

  const SecurityLesson({
    required this.id,
    required this.title,
    required this.emoji,
    required this.category,
    required this.description,
    required this.keyPoints,
    required this.quiz,
    required this.color,
    this.knowledgeValue = 10,
  });
}

/// Pregunta de quiz
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer; // Índice de la respuesta correcta
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

/// Todas las lecciones disponibles
class SecurityLessons {
  static const List<SecurityLesson> allLessons = [
    // LECCIÓN 1: Contraseñas Seguras
    SecurityLesson(
      id: 'passwords_basic',
      title: '¡Contraseñas Súper Fuertes!',
      emoji: '🔐',
      category: LessonCategory.passwords,
      color: Colors.blue,
      description:
          'Las contraseñas son como las llaves de tu casa digital. Aprende a crear contraseñas que nadie pueda adivinar.',
      keyPoints: [
        '✨ Usa contraseñas largas (al menos 8 caracteres)',
        '🔢 Combina letras, números y símbolos',
        '🙈 Nunca uses tu nombre o fecha de cumpleaños',
        '🎨 Usa contraseñas diferentes para cada sitio',
        '🤫 No compartas tus contraseñas con nadie (excepto papá/mamá)',
      ],
      quiz: [
        QuizQuestion(
          question: '¿Cuál de estas contraseñas es MÁS segura?',
          options: [
            'maria123',
            'M@r1a_S3gur@_2024!',
            '12345678',
            'password',
          ],
          correctAnswer: 1,
          explanation:
              '¡Correcto! Una buena contraseña mezcla letras mayúsculas, minúsculas, números y símbolos especiales.',
        ),
        QuizQuestion(
          question: '¿Con quién PUEDES compartir tu contraseña?',
          options: [
            'Tu mejor amigo',
            'Tu maestro',
            'Tus papás o tutores',
            'Nadie, nunca',
          ],
          correctAnswer: 2,
          explanation:
              '¡Exacto! Solo tus papás o tutores deben conocer tus contraseñas para ayudarte a mantenerte seguro.',
        ),
      ],
      knowledgeValue: 15,
    ),

    // LECCIÓN 2: Información Personal
    SecurityLesson(
      id: 'privacy_personal_info',
      title: '¡Tu Info es Especial!',
      emoji: '🛡️',
      category: LessonCategory.privacy,
      color: Colors.purple,
      description:
          '¡Tu información personal es como un tesoro! Aprende qué datos debes mantener en secreto.',
      keyPoints: [
        '🏠 Tu dirección de casa',
        '📱 Tu número de teléfono',
        '🏫 El nombre de tu escuela',
        '📅 Tu fecha de nacimiento completa',
        '📸 Fotos de tu familia o casa',
      ],
      quiz: [
        QuizQuestion(
          question: '¿Qué información NO debes compartir en internet?',
          options: [
            'Tu color favorito',
            'Tu dirección de casa',
            'Tu película favorita',
            'Tu deporte favorito',
          ],
          correctAnswer: 1,
          explanation:
              '¡Muy bien! Tu dirección es información privada que no debes compartir en línea.',
        ),
        QuizQuestion(
          question: 'Si un juego online te pide tu número de teléfono, ¿qué haces?',
          options: [
            'Lo comparto si parece un juego divertido',
            'Le pregunto a mamá o papá primero',
            'Lo invento',
            'Se lo doy a mis amigos para que lo pongan',
          ],
          correctAnswer: 1,
          explanation:
              '¡Perfecto! Siempre pregunta a un adulto de confianza antes de compartir información.',
        ),
      ],
      knowledgeValue: 15,
    ),

    // LECCIÓN 3: Extraños en Línea
    SecurityLesson(
      id: 'strangers_online',
      title: '¡Cuidado con Extraños!',
      emoji: '👥',
      category: LessonCategory.strangers,
      color: Colors.orange,
      description:
          'Igual que en la vida real, en internet también hay extraños. Aprende a identificarlos y mantenerte seguro.',
      keyPoints: [
        '🚫 No aceptes solicitudes de personas que no conoces',
        '💬 No chatees con extraños',
        '🎁 No aceptes regalos virtuales de desconocidos',
        '📹 Nunca hagas videollamadas con extraños',
        '🗣️ Cuéntale a un adulto si alguien te hace sentir incómodo',
      ],
      quiz: [
        QuizQuestion(
          question: 'Un extraño te envía una solicitud de amistad, ¿qué haces?',
          options: [
            'La acepto si tiene una foto bonita',
            'La ignoro o rechazo',
            'Le pregunto quién es',
            'Acepto solo si tiene muchos amigos',
          ],
          correctAnswer: 1,
          explanation:
              '¡Excelente! Lo mejor es ignorar o rechazar solicitudes de personas que no conoces.',
        ),
        QuizQuestion(
          question: 'Si alguien en línea te pide fotos tuyas, ¿qué haces?',
          options: [
            'Le envío fotos de mi cara',
            'Le digo que no y se lo cuento a un adulto',
            'Le envío fotos de mis juguetes',
            'Le pregunto por qué las quiere',
          ],
          correctAnswer: 1,
          explanation:
              '¡Correcto! Nunca envíes fotos a extraños y siempre cuéntale a un adulto de confianza.',
        ),
      ],
      knowledgeValue: 20,
    ),

    // LECCIÓN 4: Redes Sociales Seguras
    SecurityLesson(
      id: 'social_media_safety',
      title: '¡Redes Sociales Inteligentes!',
      emoji: '📱',
      category: LessonCategory.social,
      color: Colors.pink,
      description:
          'Las redes sociales son divertidas, pero hay reglas importantes para usarlas de forma segura.',
      keyPoints: [
        '🔒 Mantén tu perfil privado',
        '👨‍👩‍👧 Solo acepta a personas que conoces en la vida real',
        '🤔 Piensa antes de publicar (¡no se puede borrar todo!)',
        '🚫 No publiques tu ubicación en tiempo real',
        '💬 Sé amable: trata a otros como quieres ser tratado',
      ],
      quiz: [
        QuizQuestion(
          question: '¿Qué configuración de privacidad es mejor?',
          options: [
            'Perfil público para tener más seguidores',
            'Perfil privado solo para amigos conocidos',
            'Público pero sin fotos',
            'No importa la configuración',
          ],
          correctAnswer: 1,
          explanation:
              '¡Súper! Un perfil privado te protege y solo tus amigos verdaderos ven tu contenido.',
        ),
        QuizQuestion(
          question: '¿Está bien publicar fotos de tu escuela con uniforme?',
          options: [
            'Sí, está bien',
            'No, porque revela dónde vas a la escuela',
            'Sí, si no muestro mi cara',
            'Sí, si solo lo ven mis amigos',
          ],
          correctAnswer: 1,
          explanation:
              '¡Correcto! Publicar fotos con uniforme puede revelar información sobre dónde estudias.',
        ),
      ],
      knowledgeValue: 15,
    ),

    // LECCIÓN 5: Phishing y Mensajes Falsos
    SecurityLesson(
      id: 'phishing_awareness',
      title: '¡Detecta Mensajes Trampa!',
      emoji: '🎣',
      category: LessonCategory.strangers,
      color: Colors.red,
      description:
          'Algunos mensajes o correos son trampas para engañarte. Aprende a identificarlos como un detective.',
      keyPoints: [
        '🕵️ Verifica el remitente (¿lo conoces?)',
        '⚠️ Desconfía de premios o regalos inesperados',
        '🔗 No hagas clic en enlaces sospechosos',
        '❌ Si pide contraseñas o información personal, ¡es trampa!',
        '👨‍👩‍👧 Pregunta a un adulto antes de hacer clic',
      ],
      quiz: [
        QuizQuestion(
          question: 'Recibes un mensaje: "¡Ganaste 1000 dólares! Haz clic aquí". ¿Qué haces?',
          options: [
            'Hago clic inmediatamente',
            'Lo ignoro y se lo muestro a un adulto',
            'Le respondo preguntando cómo cobrar',
            'Lo comparto con mis amigos',
          ],
          correctAnswer: 1,
          explanation:
              '¡Excelente decisión! Estos mensajes suelen ser trampas. Siempre pregunta a un adulto.',
        ),
        QuizQuestion(
          question: '¿Qué indica que un correo puede ser falso?',
          options: [
            'Tiene muchos errores de ortografía',
            'Te pide que hagas clic urgentemente',
            'Viene de una dirección extraña',
            'Todas las anteriores',
          ],
          correctAnswer: 3,
          explanation:
              '¡Perfecto! Todos esos son signos de advertencia de correos falsos o phishing.',
        ),
      ],
      knowledgeValue: 18,
    ),

    // LECCIÓN 6: Ciberbullying
    SecurityLesson(
      id: 'cyberbullying_prevention',
      title: '¡Di NO al Bullying Digital!',
      emoji: '💪',
      category: LessonCategory.cyberbullying,
      color: Colors.teal,
      description:
          'El bullying en línea no está bien. Aprende qué hacer si lo ves o te pasa a ti.',
      keyPoints: [
        '❤️ Trata a todos con respeto en línea',
        '🚫 No compartas cosas que puedan herir a otros',
        '🗣️ Habla con un adulto si alguien te molesta',
        '📱 Guarda evidencia (capturas de pantalla)',
        '🤝 Apoya a tus amigos si están siendo molestados',
      ],
      quiz: [
        QuizQuestion(
          question: 'Si ves que molestan a un compañero en un chat, ¿qué haces?',
          options: [
            'Me uno a las burlas',
            'Lo ignoro',
            'Defiendo a mi compañero y aviso a un adulto',
            'Me río pero no participo',
          ],
          correctAnswer: 2,
          explanation:
              '¡Eres un héroe! Defender a otros y avisar a un adulto es lo correcto.',
        ),
        QuizQuestion(
          question: 'Alguien te envía mensajes desagradables, ¿qué NO debes hacer?',
          options: [
            'Contarle a mis papás',
            'Bloquear a esa persona',
            'Responder con insultos',
            'Guardar capturas de pantalla',
          ],
          correctAnswer: 2,
          explanation:
              '¡Correcto! Responder con insultos empeora las cosas. Es mejor bloquearlo y contárselo a un adulto.',
        ),
      ],
      knowledgeValue: 20,
    ),

    // LECCIÓN 7: Tiempo de Pantalla Saludable
    SecurityLesson(
      id: 'screen_time_balance',
      title: '¡Balance Digital Saludable!',
      emoji: '⏰',
      category: LessonCategory.screenTime,
      color: Colors.green,
      description:
          'Los dispositivos son divertidos, pero también necesitas tiempo para otras actividades importantes.',
      keyPoints: [
        '🏃 Toma descansos cada hora',
        '👀 La regla 20-20-20: cada 20 min, mira algo a 20 pies por 20 seg',
        '🌙 No uses pantallas 1 hora antes de dormir',
        '⚽ Balancea tiempo digital con juego físico',
        '👨‍👩‍👧 Respeta los límites que pongan tus papás',
      ],
      quiz: [
        QuizQuestion(
          question: '¿Cuándo NO es buena idea usar dispositivos?',
          options: [
            'Durante el desayuno',
            'Justo antes de dormir',
            'Durante las comidas familiares',
            'Todas las anteriores',
          ],
          correctAnswer: 3,
          explanation:
              '¡Perfecto! Es importante tener momentos sin pantallas para comer en familia y descansar bien.',
        ),
        QuizQuestion(
          question: '¿Qué es la regla 20-20-20?',
          options: [
            'Jugar 20 minutos de cada juego',
            'Cada 20 min, mirar algo a 20 pies por 20 seg',
            'Tomar 20 descansos de 20 segundos',
            'Usar la pantalla solo 20 minutos al día',
          ],
          correctAnswer: 1,
          explanation:
              '¡Excelente! Esta regla ayuda a descansar tus ojos y prevenir cansancio visual.',
        ),
      ],
      knowledgeValue: 12,
    ),

    // LECCIÓN 8: Descargas y Apps Seguras
    SecurityLesson(
      id: 'safe_downloads',
      title: '¡Descargas Seguras!',
      emoji: '📥',
      category: LessonCategory.privacy,
      color: Colors.indigo,
      description:
          'No todo lo que está en internet es seguro descargar. Aprende a elegir apps y juegos seguros.',
      keyPoints: [
        '🏪 Solo descarga de tiendas oficiales (App Store, Google Play)',
        '⭐ Lee las reseñas y calificaciones',
        '🔍 Revisa los permisos que pide la app',
        '👨‍👩‍👧 Pide permiso a un adulto antes de descargar',
        '🦠 No descargues archivos de correos desconocidos',
      ],
      quiz: [
        QuizQuestion(
          question: '¿Dónde es SEGURO descargar aplicaciones?',
          options: [
            'De cualquier página web',
            'De tiendas oficiales como App Store o Google Play',
            'De correos que me envían',
            'De sitios que prometen juegos gratis',
          ],
          correctAnswer: 1,
          explanation:
              '¡Correcto! Las tiendas oficiales verifican las apps antes de publicarlas.',
        ),
        QuizQuestion(
          question: 'Una app gratis te pide acceso a tu cámara, contactos y ubicación, ¿qué haces?',
          options: [
            'Acepto todos los permisos',
            'Le pregunto a un adulto si es necesario',
            'Solo acepto la cámara',
            'Los acepto pero no uso la app',
          ],
          correctAnswer: 1,
          explanation:
              '¡Bien pensado! Siempre pregunta a un adulto sobre permisos sospechosos.',
        ),
      ],
      knowledgeValue: 15,
    ),

    // LECCIÓN 9: Privacidad de Fotos y Videos
    SecurityLesson(
      id: 'photo_video_privacy',
      title: '¡Fotos y Videos Inteligentes!',
      emoji: '📸',
      category: LessonCategory.privacy,
      color: Colors.amber,
      description:
          'Las fotos y videos son especiales. Aprende a compartirlos de forma segura y responsable.',
      keyPoints: [
        '🤔 Piensa antes de publicar: ¿es apropiada?',
        '👥 Pide permiso antes de publicar fotos de otros',
        '🏠 No publiques fotos que muestren dónde vives',
        '🔒 Usa configuraciones de privacidad',
        '⏰ Recuerda: en internet, las cosas pueden quedar para siempre',
      ],
      quiz: [
        QuizQuestion(
          question: 'Tu amigo te pide que no publiques una foto de él, ¿qué haces?',
          options: [
            'La publico de todos modos',
            'La publico pero lo etiqueto',
            'Respeto su decisión y no la publico',
            'La publico pero sin su cara',
          ],
          correctAnswer: 2,
          explanation:
              '¡Excelente! Respetar la privacidad de los demás es muy importante.',
        ),
        QuizQuestion(
          question: '¿Qué debe evitar aparecer en tus fotos públicas?',
          options: [
            'Tu cara',
            'Tu comida favorita',
            'El número de tu casa o placas de autos',
            'Tus juguetes',
          ],
          correctAnswer: 2,
          explanation:
              '¡Correcto! Información como números de casa puede revelar dónde vives.',
        ),
      ],
      knowledgeValue: 15,
    ),

    // LECCIÓN 10: Qué Hacer si Algo Malo Pasa
    SecurityLesson(
      id: 'report_problems',
      title: '¡Pide Ayuda Cuando lo Necesites!',
      emoji: '🆘',
      category: LessonCategory.cyberbullying,
      color: Colors.deepOrange,
      description:
          'Si algo te hace sentir mal, asustado o confundido en línea, ¡no estás solo! Siempre hay alguien que puede ayudarte.',
      keyPoints: [
        '🗣️ Habla con un adulto de confianza inmediatamente',
        '📱 Usa las opciones de "Reportar" o "Bloquear"',
        '📷 Guarda evidencia (capturas de pantalla)',
        '❤️ No es tu culpa si algo malo pasa',
        '🤝 Ayuda a tus amigos si necesitan reportar algo',
      ],
      quiz: [
        QuizQuestion(
          question: 'Ves algo que te hace sentir incómodo en internet, ¿qué haces PRIMERO?',
          options: [
            'Lo ignoro y sigo navegando',
            'Se lo cuento a un adulto de confianza',
            'Le tomo captura pero no digo nada',
            'Se lo cuento solo a mis amigos',
          ],
          correctAnswer: 1,
          explanation:
              '¡Perfecto! Hablar con un adulto de confianza es siempre el primer paso.',
        ),
        QuizQuestion(
          question: 'Si un adulto te pregunta sobre algo que viste en línea, ¿qué haces?',
          options: [
            'Miento para no meterme en problemas',
            'Digo la verdad, no me voy a meter en problemas por reportar',
            'Cambio de tema',
            'Digo que no recuerdo',
          ],
          correctAnswer: 1,
          explanation:
              '¡Excelente! Decir la verdad ayuda a mantenerte seguro. Nunca te meterás en problemas por reportar algo malo.',
        ),
      ],
      knowledgeValue: 20,
    ),
  ];

  /// Obtiene una lección por ID
  static SecurityLesson? getLessonById(String id) {
    try {
      return allLessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene lecciones por categoría
  static List<SecurityLesson> getLessonsByCategory(LessonCategory category) {
    return allLessons.where((lesson) => lesson.category == category).toList();
  }

  /// Obtiene el progreso total (0.0 - 1.0)
  static double getProgress(Set<String> completedLessonIds) {
    return completedLessonIds.length / allLessons.length;
  }
}
