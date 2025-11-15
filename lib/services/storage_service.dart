// PERSONNE B - Service de sauvegarde Firebase
import 'dart:io';
import '../models/plant.dart';
// TODO PERSONNE B: Importer Firebase après configuration
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // TODO PERSONNE B: Implémenter cette fonction
  // Cette fonction sauvegarde une plante dans Firebase
  Future<void> sauvegarderPlante(String nom, File image) async {
    // 1. Uploader l'image dans Firebase Storage
    // 2. Récupérer l'URL de l'image uploadée
    // 3. Créer un objet Plant avec l'URL
    // 4. Sauvegarder dans Firestore (collection 'plants')
    
    throw UnimplementedError('À implémenter par Personne B');
  }

  // TODO PERSONNE B: Implémenter cette fonction
  // Cette fonction récupère toutes les plantes depuis Firebase
  Future<List<Plant>> getHistorique() async {
    // 1. Lire la collection 'plants' dans Firestore
    // 2. Convertir les documents en List<Plant>
    // 3. Retourner la liste triée par date
    
    throw UnimplementedError('À implémenter par Personne B');
  }

  // TODO PERSONNE B: Bonus - Fonction pour supprimer une plante
  Future<void> supprimerPlante(Plant plant) async {
    // 1. Supprimer le document dans Firestore
    // 2. Supprimer l'image dans Firebase Storage
    throw UnimplementedError('Optionnel - À implémenter par Personne B');
  }
}
