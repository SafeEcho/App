import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'tamagotchi/pet_model.dart';
import 'tamagotchi/persistence/pet_persistence.dart';
import 'tamagotchi/screens/pet_home_screen.dart';
import 'tamagotchi/screens/welcome_screen.dart';
import 'tamagotchi/screens/echo_panel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Configurar orientación vertical (portrait) para mejor experiencia móvil
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const EchomimiApp());
}

class EchomimiApp extends StatefulWidget {
  const EchomimiApp({super.key});

  @override
  State<EchomimiApp> createState() => _EchomimiAppState();
}

class _EchomimiAppState extends State<EchomimiApp> {
  late final PetModel _petModel;
  bool _isLoading = true;
  bool _showWelcome = true;
  bool _showLevelSelection = false;

  @override
  void initState() {
    super.initState();
    _initializePet();
  }

  Future<void> _initializePet() async {
    final persistence = LocalStoragePetPersistence();
    // Limpiar datos anteriores para asegurar que EchoMimi se use como nombre
    await persistence.clearPetData();
    
    _petModel = PetModel(persistence);
    await _petModel.loadData();
    // Asegurar que el nombre es EchoMimi
    _petModel.setName('EchoMimi');

    setState(() {
      _isLoading = false;
    });
  }

  void _onStartApp() {
    setState(() {
      _showWelcome = false;
      _showLevelSelection = true;
    });
  }

  void _onLevelSelected(int level) {
    setState(() {
      _showLevelSelection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.shade200,
                  Colors.blue.shade100,
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🔐',
                    style: TextStyle(fontSize: 80),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'ECHOMIMI',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider<PetModel>.value(
      value: _petModel,
      child: MaterialApp(
        title: 'ECHOMIMI - Aprende Seguridad Digital',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        home: _showWelcome
            ? WelcomeScreen(onStart: _onStartApp)
            : _showLevelSelection
                ? EchoPanelScreen(onLevelSelected: _onLevelSelected)
                : const PetHomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _petModel.dispose();
    super.dispose();
  }
}
