import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pet_model.dart';
import '../services/groq_service.dart';
import '../services/elevenlabs_service.dart';

/// Pantalla de chat con ECHOMIMI por voz y texto
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  late stt.SpeechToText _speech;
  late AudioPlayer _audioPlayer;
  late GroqService _groqService;
  late ElevenLabsService _elevenLabsService;
  late AnimationController _pulseController;

  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _audioPlayer = AudioPlayer();

    // Inicializar servicios con las API keys del .env
    _groqService = GroqService(dotenv.env['GROQ_API_KEY'] ?? '');
    _elevenLabsService = ElevenLabsService(
      dotenv.env['ELEVEN_API_KEY'] ?? '',
      dotenv.env['VOICE_ID'] ?? '',
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _initSpeech();
    _addWelcomeMessage();
  }

  void _initSpeech() async {
    await _speech.initialize();
    setState(() {});
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: '¡Hola! 💜 Soy ECHOMIMI, tu amiguit@ virtual. ¿Quieres hablar conmigo? Puedes escribir o presionar el botón de micrófono para hablar. ✨',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() async {
    if (!_isListening && _speech.isAvailable) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
        },
        localeId: 'es_ES',
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);

      if (_lastWords.isNotEmpty) {
        _sendMessage(_lastWords);
        _lastWords = '';
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isProcessing = true;
    });
    _scrollToBottom();

    try {
      // Obtener respuesta de GROQ
      final petName = context.read<PetModel>().name;
      final response = await _groqService.sendMessage(text, petName: petName);

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isProcessing = false;
      });
      _scrollToBottom();

      // Convertir respuesta a audio con ElevenLabs
      _speakResponse(response);

      // Dar experiencia por interactuar
      context.read<PetModel>().play();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: '¡Ups! 😅 Tuve un problemita. ¿Intentamos de nuevo?',
          isUser: false,
        ));
        _isProcessing = false;
      });
    }
  }

  Future<void> _speakResponse(String text) async {
    setState(() => _isSpeaking = true);

    final audioPath = await _elevenLabsService.textToSpeech(text);

    if (audioPath != null) {
      await _audioPlayer.play(DeviceFileSource(audioPath));

      // Esperar a que termine de reproducir
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() => _isSpeaking = false);
      });
    } else {
      setState(() => _isSpeaking = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '💬 Chat con ECHOMIMI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF64B5F6),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isProcessing ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isProcessing && index == _messages.length) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Indicador de estado
            if (_isSpeaking || _isListening)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Icon(
                          _isListening ? Icons.mic : Icons.volume_up,
                          color: Colors.white,
                          size: 20 + (_pulseController.value * 8),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isListening ? 'Escuchando...' : 'ECHOMIMI hablando...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Área de entrada
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Campo de texto
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) {
                          _sendMessage(text);
                          _textController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón de enviar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64B5F6).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        _sendMessage(_textController.text);
                        _textController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón de micrófono
                  GestureDetector(
                    onLongPressStart: (_) => _startListening(),
                    onLongPressEnd: (_) => _stopListening(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.red
                            : const Color(0xFF9575CD),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.red : const Color(0xFF9575CD))
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF64B5F6)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 15,
            color: message.isUser ? Colors.white : Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_pulseController.value + delay) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFF64B5F6).withOpacity(0.3),
              const Color(0xFF64B5F6),
              value,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

/// Modelo de mensaje de chat
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
