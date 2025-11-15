// PERSONNE A - Écran de capture photo
import 'package:flutter/material.dart';
import 'dart:io';
// TODO PERSONNE A: Importer image_picker après l'avoir ajouté dans pubspec.yaml
// import 'package:image_picker/image_picker.dart';
import '../services/vision_api.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final VisionApiService _visionService = VisionApiService();

  // TODO PERSONNE A: Fonction pour prendre une photo avec ImagePicker
  Future<void> _prendrePhoto() async {
    // Utiliser ImagePicker.pickImage(source: ImageSource.camera)
    // Sauvegarder dans _image et faire setState
  }

  // TODO PERSONNE A: Fonction pour analyser la plante
  Future<void> _analyserPlante() async {
    // Vérifier que _image n'est pas null
    // Appeler _visionService.analyzerPlante(_image!)
    // Naviguer vers ResultScreen avec le nom de la plante
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Plante 🌿'),
        actions: [
          // TODO PERSONNE A: IconButton pour naviguer vers HistoryScreen
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO PERSONNE A: Afficher l'image si _image != null, sinon afficher une icône
            
            const SizedBox(height: 20),
            
            // TODO PERSONNE A: ElevatedButton "Prendre une photo" qui appelle _prendrePhoto
            
            const SizedBox(height: 10),
            
            // TODO PERSONNE A: ElevatedButton "Analyser" (visible seulement si _image != null)
          ],
        ),
      ),
    );
  }
}
