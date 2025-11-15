// PERSONNE B - Service d'appel à l'API de vision
import 'dart:io';

class VisionApiService {
  // TODO PERSONNE B: Ajouter votre clé API ici
  static const String apiKey = 'VOTRE_CLE_API';
  static const String apiUrl = 'https://api.example.com/identify';

  // TODO PERSONNE B: Implémenter cette fonction
  // Cette fonction envoie l'image à l'API et retourne le nom de la plante
  Future<String> analyzerPlante(File image) async {
    // 1. Convertir l'image en base64 ou multipart
    // 2. Faire l'appel HTTP POST à l'API
    // 3. Parser la réponse JSON
    // 4. Retourner le nom de la plante
    
    throw UnimplementedError('À implémenter par Personne B');
  }

  // TODO PERSONNE B: Gérer les erreurs
  // - Pas de connexion internet
  // - API qui ne répond pas
  // - Image non reconnue
}
