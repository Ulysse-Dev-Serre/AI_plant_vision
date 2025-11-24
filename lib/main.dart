// PERSONNE A - Point d'entrée de l'application amélioré
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';
import 'screens/camera_screen.dart';
import 'screens/history_screen.dart';
import 'services/storage_service.dart';
import 'services/vision_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chargement des variables d'environnement
  await dotenv.load(fileName: ".env");

  // Initialisation Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VisionPlanteApp());
}

class VisionPlanteApp extends StatelessWidget {
  const VisionPlanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vision Plante',
      theme: _appTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const CameraScreen(),
        '/history': (_) => const HistoryScreen(),
        '/test': (_) => const TestFullIntegrationScreen(),
      },
    );
  }

  /// 🌿 Thème moderne, doux & professionnel
  ThemeData _appTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6AA87E),
        background: const Color(0xFFF5F8F1),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F8F1),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2F3E46),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// TEST FULL INTÉGRATION – Version améliorée avec UI moderne
//////////////////////////////////////////////////////////////////////////////

class TestFullIntegrationScreen extends StatefulWidget {
  const TestFullIntegrationScreen({super.key});

  @override
  State<TestFullIntegrationScreen> createState() => _TestFullIntegrationScreenState();
}

class _TestFullIntegrationScreenState extends State<TestFullIntegrationScreen> {
  String _status = "Prêt pour le test complet";
  bool _isLoading = false;
  String? _resultatNom;

  Future<void> _lancerTestComplet() async {
    setState(() {
      _isLoading = true;
      _status = "📂 Préparation de l'image…";
      _resultatNom = null;
    });

    try {
      // A. Copie l'image de test dans un vrai fichier temporaire
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/plante_test.jpg');

      final byteData = await rootBundle.load('test_assets/plant_test3.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // B. Analyse Vision API
      setState(() => _status = "🔍 Analyse via Vision API…");
      final result = await VisionApiService().analyzerPlante(file);

      final nomPlante = result['nom'] ?? "Inconnue";
      final description = result['description'] ?? "Aucune info";

      setState(() {
        _resultatNom = "$nomPlante – $description";
        _status = "💾 Sauvegarde dans Firestore…";
      });

      // C. Sauvegarde
      await StorageService().sauvegarderPlante(nomPlante, description, file);

      setState(() {
        _status = "✅ Succès total !\nPlante : $nomPlante";
      });

    } catch (e) {
      setState(() => _status = "❌ Erreur : $e");
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vision Plante 🌿"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Identifiez votre plante en un clic",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6AA87E),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            if (_resultatNom != null)
              Text(
                "🌿 $_resultatNom",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
              ),

            const SizedBox(height: 25),

            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _lancerTestComplet,
                icon: const Icon(Icons.science),
                label: const Text("LANCER TEST : VISION + STORAGE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6AA87E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
