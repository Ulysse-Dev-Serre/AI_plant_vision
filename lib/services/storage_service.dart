import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/plant.dart';

/// PROVIDER : Service responsable de la persistance des données
/// Ce service fournit l'accès à la base de données (Firestore) et au stockage de fichiers LOCAL.
class StorageService {
  // Instance Firestore (Base de données partagée)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Nom de la collection dans Firestore
  static const String collectionName = 'plantes';

  /// Sauvegarde une nouvelle plante (Image Locale + Données Cloud)
  /// 1. Copie l'image dans un dossier permanent du téléphone
  /// 2. Sauvegarde les infos (dont le chemin local) dans Firestore
  Future<void> sauvegarderPlante(String nom, String description, File imageFile) async {
    try {
      // 1. Sauvegarde LOCALE de l'image
      // On récupère le dossier permanent de l'application
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final String localPath = path.join(directory.path, fileName);
      
      // On copie l'image du cache vers le stockage permanent
      await imageFile.copy(localPath);
      print("Image sauvegardée localement : $localPath");

      // 2. Création de l'objet Plant
      DocumentReference docRef = _firestore.collection(collectionName).doc();
      
      Plant nouvellePlante = Plant(
        id: docRef.id,
        nom: nom,
        description: description, // On sauvegarde la description
        imagePath: localPath,
        imageUrl: null,
        date: DateTime.now(),
      );

      // 3. Sauvegarde dans Firestore
      await docRef.set(nouvellePlante.toMap());
      
      print("Plante sauvegardée avec succès dans Firestore ! ID: ${docRef.id}");
      
    } catch (e) {
      print("Erreur lors de la sauvegarde : $e");
      throw Exception("Impossible de sauvegarder la plante");
    }
  }

  /// Récupère l'historique complet des plantes scannées
  /// Retourne un [Future] contenant la liste des plantes (Data Provider)
  Future<List<Plant>> getHistorique() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .orderBy('date', descending: true) // Les plus récentes en premier
          .get();

      return snapshot.docs.map((doc) {
        return Plant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération de l'historique : $e");
      return [];
    }
  }
  
  /// Supprime une plante de l'historique 
  Future<void> supprimerPlante(String plantId) async {
     await _firestore.collection(collectionName).doc(plantId).delete();
     // TODO: Idéalement, supprimer aussi le fichier local pour nettoyer
  }
}
