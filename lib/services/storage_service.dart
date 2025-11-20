import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../models/plant.dart';

/// PROVIDER : Service responsable de la persistance des données
/// Ce service fournit l'accès à la base de données (Firestore) et au stockage de fichiers (Storage).
class StorageService {
  // Instances Firebase (Singleton)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Nom de la collection dans Firestore
  static const String collectionName = 'plantes';

  /// Sauvegarde une nouvelle plante (Image + Données)
  /// Action complexe qui enchaîne Upload Image -> Récupération URL -> Sauvegarde BDD
  Future<void> sauvegarderPlante(String nom, File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      String storagePath = 'plantes_images/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // 1. Upload de l'image vers Firebase Storage
      TaskSnapshot snapshot = await _storage.ref(storagePath).putFile(imageFile);
      
      // 2. Récupération de l'URL de téléchargement
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // 3. Création de l'objet Plant
      // On utilise .doc() vide pour générer un ID automatique
      DocumentReference docRef = _firestore.collection(collectionName).doc();
      
      Plant nouvellePlante = Plant(
        id: docRef.id,
        nom: nom,
        imagePath: imageFile.path, // Chemin local (pour affichage immédiat si besoin)
        imageUrl: downloadUrl,     // URL Cloud (pour affichage distant/partagé)
        date: DateTime.now(),
      );

      // 4. Sauvegarde dans Firestore
      await docRef.set(nouvellePlante.toMap());
      
      print("Plante sauvegardée avec succès ! ID: ${docRef.id}");
      
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
  }
}
