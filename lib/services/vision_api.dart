import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_logger.dart';

/// PROVIDER : Service responsable de la reconnaissance visuelle
/// Ce service fournit l'intelligence artificielle à l'application.
class VisionApiService {
  //  clé API Plant.id
  //  Récupérée depuis le fichier .env (sécurité)
  String get _apiKey => dotenv.env['PLANT_ID_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.plant.id/v2/identify';

  /// Analyse une image et retourne les détails de la plante.
  /// Retourne une Map : {'nom': '...', 'description': '...'}
  ///
  /// Utilise un [Future] car l'appel réseau prend du temps (Asynchrone).
  Future<Map<String, String>> analyzerPlante(File imageFile) async {
    if (_apiKey.isEmpty) {
      AppLogger.error('Clé API non trouvée dans le fichier .env');
      return {'nom': 'Erreur Config', 'description': 'Clé API manquante'};
    }

    try {
      AppLogger.info('Début de l\'analyse d\'image...');
      
      // Conversion de l'image en base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      
      AppLogger.debug('Image convertie en Base64 (${imageBytes.length} bytes)');

      // Préparation de la requête
      Map<String, dynamic> body = {
        "images": [base64Image],
        "modifiers": ["crops_fast", "similar_images"],
        "plant_details": ["common_names", "url", "wiki_description", "taxonomy"]
      };

      // Envoi de la requête POST
      AppLogger.debug('Envoi requête HTTP vers $_apiUrl');
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Api-Key": _apiKey,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        AppLogger.success('Réponse API reçue (200 OK)');
        final data = jsonDecode(response.body);
        
        // Vérification si des suggestions existent
        if (data['suggestions'] != null && (data['suggestions'] as List).isNotEmpty) {
          // On prend la première suggestion (la plus probable)
          final suggestion = data['suggestions'][0];
          final plantName = suggestion['plant_name']; // Nom scientifique
          final probability = suggestion['probability'];
          
          AppLogger.info('Plante identifiée: $plantName (Probabilité: ${(probability * 100).toStringAsFixed(1)}%)');

          // Récupération des noms communs
          String description = "";
          if (suggestion['plant_details'] != null && suggestion['plant_details']['common_names'] != null) {
            List<dynamic> commonNames = suggestion['plant_details']['common_names'];
            if (commonNames.isNotEmpty) {
              description = commonNames.take(3).join(", "); // On prend les 3 premiers
            }
          }
          
          return {
            'nom': plantName ?? "Nom introuvable",
            'description': description
          };
        } else {
          AppLogger.warning('Aucune plante détectée sur l\'image');
          return {'nom': "Non identifié", 'description': "Aucune plante détectée sur l'image"};
        }
      } else {
        AppLogger.error("Erreur API (${response.statusCode})", response.body);
        return {'nom': "Erreur API", 'description': "Code ${response.statusCode}"};
      }
    } catch (e, stack) {
      AppLogger.error("Exception lors de l'analyse", e, stack);
      return {'nom': "Erreur Connexion", 'description': e.toString()};
    }
  }
}
