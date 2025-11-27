import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/plant.dart';
import '../utils/app_logger.dart';

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
  Future<void> sauvegarderPlante(
    String nom, 
    String description, 
    File imageFile, {
    String? wikiDescription,
    double confiance = 0.0,
    double? isPlantProbability,
  }) async {
    try {
      // 1. Sauvegarde LOCALE de l'image
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final String localPath = path.join(directory.path, fileName);
      
      await imageFile.copy(localPath);
      AppLogger.file('Image sauvegardée localement', localPath);

      // 2. Création de l'objet Plant avec tous les détails
      DocumentReference docRef = _firestore.collection(collectionName).doc();
      
      AppLogger.debug('Sauvegarde wikiDescription: ${wikiDescription != null ? "${wikiDescription.substring(0, wikiDescription.length > 50 ? 50 : wikiDescription.length)}..." : "NULL"}');
      AppLogger.debug('Sauvegarde confiance: $confiance');
      
      Plant nouvellePlante = Plant(
        id: docRef.id,
        nom: nom,
        description: description,
        imagePath: localPath,
        imageUrl: null,
        date: DateTime.now(),
        wikiDescription: wikiDescription,
        confiance: confiance,
        isPlantProbability: isPlantProbability,
      );

      // 3. Sauvegarde dans Firestore
      AppLogger.firestore(
        'Tentative de sauvegarde', 
        collection: collectionName, 
        docId: docRef.id, 
        data: nouvellePlante.toMap()
      );
      
      await docRef.set(nouvellePlante.toMap());
      
      AppLogger.success('Plante sauvegardée dans Firestore ! ID: ${docRef.id}');
      
    } catch (e, stackTrace) {
      AppLogger.error('Impossible de sauvegarder la plante', e, stackTrace);
      throw Exception("Impossible de sauvegarder la plante: $e");
    }
  }

  /// Récupère l'historique complet des plantes scannées
  /// Retourne un [Future] contenant la liste des plantes (Data Provider)
  Future<List<Plant>> getHistorique() async {
    try {
      AppLogger.info('Récupération de l\'historique...');

      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .orderBy('date', descending: true) // Les plus récentes en premier
          .get();

      final plants = snapshot.docs.map((doc) {
        return Plant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      AppLogger.success('${plants.length} plantes récupérées');
      return plants;
    } catch (e) {
      AppLogger.error('Erreur lors de la récupération de l\'historique', e);
      return [];
    }
  }
  
  /// Supprime une plante de l'historique 
  Future<void> supprimerPlante(String plantId) async {
     try {
       AppLogger.info('Suppression de la plante $plantId');
       await _firestore.collection(collectionName).doc(plantId).delete();
       AppLogger.success('Plante supprimée');
       // TODO: Idéalement, supprimer aussi le fichier local pour nettoyer
     } catch (e) {
       AppLogger.error('Erreur lors de la suppression', e);
       rethrow;
     }
  }
}
