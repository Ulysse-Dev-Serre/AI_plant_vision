// PERSONNE A - Point d'entrée de l'application
import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const VisionPlanteApp());
}

class VisionPlanteApp extends StatelessWidget {
  const VisionPlanteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Plante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // TODO PERSONNE A: Page de démarrage = CameraScreen
      home: const CameraScreen(),
      
      // TODO PERSONNE A: Définir les routes (optionnel mais recommandé)
      routes: {
        '/camera': (context) => const CameraScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
