// PERSONNE A - Écran de résultat
import 'package:flutter/material.dart';
import 'dart:io';
import '../services/storage_service.dart';
import 'camera_screen.dart'; // Pour la navigation "Nouvelle analyse"
import '../utils/app_logger.dart';

class ResultScreen extends StatelessWidget {
  final String nomPlante;
  final String description;
  final File image;

  const ResultScreen({
    Key? key,
    required this.nomPlante,
    required this.description,
    required this.image,
  }) : super(key: key);

  // Fonction pour sauvegarder la plante
  Future<void> _sauvegarder(BuildContext context) async {
    try {
      AppLogger.info("Clic bouton Sauvegarder - Plante: $nomPlante");
      
      final storageService = StorageService();
      await storageService.sauvegarderPlante(nomPlante, description, image);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plante sauvegardée avec succès !')),
        );
        // Retourner à l'écran précédent (CameraScreen)
        Navigator.pop(context);
      }
    } catch (e) {
      AppLogger.error("Erreur UI lors de la sauvegarde", e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Affichage de l'image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Nom de la plante
                Text(
                  nomPlante,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 10),
                
                // Description
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                
                const SizedBox(height: 30),
                
                // Bouton Sauvegarder
                ElevatedButton.icon(
                  onPressed: () => _sauvegarder(context),
                  icon: const Icon(Icons.save),
                  label: const Text("Sauvegarder"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Bouton Nouvelle analyse
                TextButton.icon(
                  onPressed: () {
                    // Retourne à CameraScreen
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Nouvelle analyse"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
