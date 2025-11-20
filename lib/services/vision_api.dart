import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// PROVIDER : Service responsable de la reconnaissance visuelle
/// Ce service fournit l'intelligence artificielle à l'application.
class VisionApiService {
  //  clé API Plant.id
  static const String _apiKey = 'ZGmJKD1KrVZsPigLTbnAu4hcW9m1lO4s0pcXlD9VTJhOlldayo';
  static const String _apiUrl = 'https://api.plant.id/v2/identify';

  /// Analyse une image et retourne le nom de la plante détectée.
  /// Retourne "Plante inconnue" si l'analyse échoue.
  ///
  /// Utilise un [Future] car l'appel réseau prend du temps (Asynchrone).
  Future<String> analyzerPlante(File imageFile) async {
    try {
      // Conversion de l'image en base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Préparation de la requête
      Map<String, dynamic> body = {
        "images": [base64Image],
        "modifiers": ["crops_fast", "similar_images"],
        "plant_details": ["common_names", "url", "wiki_description", "taxonomy"]
      };

      // Envoi de la requête POST
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Api-Key": _apiKey,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Vérification si des suggestions existent
        if (data['suggestions'] != null && (data['suggestions'] as List).isNotEmpty) {
          // On prend la première suggestion (la plus probable)
          final suggestion = data['suggestions'][0];
          final plantName = suggestion['plant_name']; // Nom scientifique ou commun
          
          // Si on veut le nom commun en français (si disponible)
          // Note: Plant.id retourne souvent en anglais par défaut
          return plantName ?? "Nom introuvable";
        } else {
          return "Aucune plante détectée";
        }
      } else {
        print("Erreur API (${response.statusCode}): ${response.body}");
        return "Erreur lors de l'analyse";
      }
    } catch (e) {
      print("Erreur Exception: $e");
      return "Erreur de connexion";
    }
  }
}
