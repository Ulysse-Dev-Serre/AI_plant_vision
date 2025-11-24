// PERSONNE A - Point d'entrée de l'application
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Pour lire les assets
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'screens/camera_screen.dart';
import 'screens/history_screen.dart';
import 'services/storage_service.dart';
import 'services/vision_api.dart';
import 'utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Chargement des variables d'environnement
  await dotenv.load(fileName: ".env");
  AppLogger.info("Variables d'environnement chargées");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppLogger.success("Firebase initialisé");
  
  runApp(const VisionPlanteApp());
}

class VisionPlanteApp extends StatelessWidget {
  const VisionPlanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Plante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Point d'entrée principal de l'application
      home: const CameraScreen(), 
    );
  }
}

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
      _status = "1. Préparation de l'image...";
      _resultatNom = null;
    });

    try {
      // A. Convertir l'asset en fichier réel (car l'API veut un File)
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/test_plant_final.jpg');
      
      // On lit l'asset 'test_assets/plant_test2.jpg'
      // ATTENTION: Assurez-vous que le fichier existe bien dans le dossier test_assets
      final byteData = await rootBundle.load('test_assets/plant_test3.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      // B. Appel API Vision
      setState(() => _status = "2. Analyse Vision (Plant.id)...");
      final visionService = VisionApiService();
      final resultat = await visionService.analyzerPlante(file);
      final nomPlante = resultat['nom']!;
      final description = resultat['description']!;
      
      setState(() => _status = "Plante identifiée : $nomPlante\nInfos: $description\n3. Sauvegarde en cours...");
      _resultatNom = "$nomPlante\n($description)";

      // C. Sauvegarde Storage + Firestore
      final storageService = StorageService();
      await storageService.sauvegarderPlante(nomPlante, description, file);

      setState(() => _status = "✅ SUCCÈS TOTAL !\n\nPlante: $nomPlante\nSauvegardée dans Firestore.");
      
    } catch (e) {
      setState(() => _status = "❌ ERREUR : $e");
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Full Intégration")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              if (_resultatNom != null) ...[
                Text("Résultat API : $_resultatNom", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 20),
              ],
              if (_isLoading) const CircularProgressIndicator()
              else ElevatedButton.icon(
                onPressed: _lancerTestComplet,
                icon: const Icon(Icons.science),
                label: const Text("LANCER TEST : VISION + STORAGE"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
