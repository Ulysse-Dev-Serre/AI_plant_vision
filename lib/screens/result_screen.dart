// PERSONNE A - Écran de résultat
import 'package:flutter/material.dart';
import 'dart:io';
import '../services/storage_service.dart';

class ResultScreen extends StatelessWidget {
  final String nomPlante;
  final File image;

  const ResultScreen({
    Key? key,
    required this.nomPlante,
    required this.image,
  }) : super(key: key);

  // TODO PERSONNE A: Fonction pour sauvegarder la plante
  Future<void> _sauvegarder(BuildContext context) async {
    // Créer une instance de StorageService
    // Appeler storageService.sauvegarderPlante(nomPlante, image)
    // Afficher un SnackBar "Plante sauvegardée !"
    // Navigator.pop pour retourner à l'écran précédent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO PERSONNE A: Image.file pour afficher l'image
              
              const SizedBox(height: 20),
              
              // TODO PERSONNE A: Text pour afficher nomPlante (gros et en gras)
              
              const SizedBox(height: 30),
              
              // TODO PERSONNE A: ElevatedButton "Sauvegarder" qui appelle _sauvegarder
              
              const SizedBox(height: 10),
              
              // TODO PERSONNE A: TextButton "Nouvelle analyse" qui retourne à CameraScreen
            ],
          ),
        ),
      ),
    );
  }
}
