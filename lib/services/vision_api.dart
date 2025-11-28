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
  /// Retourne une Map avec des types dynamiques pour inclure la probabilité, etc.
  Future<Map<String, dynamic>> analyzerPlante(File imageFile) async {
    if (_apiKey.isEmpty) {
      AppLogger.warning('Clé API non trouvée dans le fichier .env');
      return {'nom': 'Erreur Config', 'description': 'Clé API manquante', 'confiance': 0.0};
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
          final double probability = suggestion['probability'] ?? 0.0;
          
          AppLogger.info('Plante identifiée: $plantName (Probabilité: ${(probability * 100).toStringAsFixed(1)}%)');

          // Récupération des noms communs
          String commonNames = "";
          if (suggestion['plant_details'] != null && suggestion['plant_details']['common_names'] != null) {
            List<dynamic> names = suggestion['plant_details']['common_names'];
            if (names.isNotEmpty) {
              commonNames = names.take(3).join(", ");
            }
          }

          // Récupération description Wiki
          String wikiDescription = "";
          if (suggestion['plant_details'] != null && 
              suggestion['plant_details']['wiki_description'] != null &&
              suggestion['plant_details']['wiki_description']['value'] != null) {
            wikiDescription = suggestion['plant_details']['wiki_description']['value'];
            AppLogger.debug('Wiki description trouvée: ${wikiDescription.substring(0, wikiDescription.length > 100 ? 100 : wikiDescription.length)}...');
          } else {
            AppLogger.debug('Aucune description Wiki disponible pour cette plante');
          }
          
          return {
            'nom': plantName ?? "Nom introuvable",
            'description': commonNames, // Noms communs
            'wikiDescription': wikiDescription, // Description détaillée
            'confiance': probability, // Probabilité (0.0 à 1.0)
            'isPlantProbability': data['is_plant_probability'] ?? 0.0, // Proba que ce soit une plante
          };
        } else {
          return {'nom': "Non identifié", 'description': "Aucune plante détectée", 'confiance': 0.0};
        }
      } else {
        AppLogger.error('Erreur API (${response.statusCode})', response.body);
        return {'nom': "Erreur API", 'description': "Code ${response.statusCode}", 'confiance': 0.0};
      }
    } catch (e) {
      AppLogger.error('Erreur lors de l\'analyse', e);
      return {'nom': "Erreur Connexion", 'description': e.toString(), 'confiance': 0.0};
    }
  }
}
