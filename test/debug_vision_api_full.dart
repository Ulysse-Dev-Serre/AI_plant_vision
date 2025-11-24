import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Ce script s'exécute en ligne de commande avec : 
// dart test/debug_vision_api_full.dart

void main() async {
  print("🔍 Démarrage du test complet de l'API Vision...");

  // 1. Récupération de la clé API depuis le fichier .env
  // (On le fait manuellement ici pour ne pas dépendre de Flutter)
  String apiKey = "";
  try {
    final envFile = File('.env');
    if (!envFile.existsSync()) {
      print("❌ ERREUR : Fichier .env introuvable à la racine.");
      return;
    }
    
    final lines = await envFile.readAsLines();
    for (var line in lines) {
      if (line.startsWith('PLANT_ID_API_KEY=')) {
        apiKey = line.split('=')[1].trim();
      }
    }
    
    if (apiKey.isEmpty) {
      print("❌ ERREUR : Clé PLANT_ID_API_KEY non trouvée dans .env");
      return;
    }
    print("✅ Clé API récupérée.");
    
  } catch (e) {
    print("❌ Erreur lecture .env : $e");
    return;
  }

  // 2. Chargement de l'image de test
  final String imagePath = 'test_assets/plant_test3.jpg'; // Vous pouvez changer le chiffre ici
  final File imageFile = File(imagePath);
  
  if (!imageFile.existsSync()) {
    print("❌ ERREUR : Image de test introuvable ($imagePath)");
    return;
  }
  print("✅ Image chargée : $imagePath");

  // 3. Préparation de la requête
  try {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> body = {
      "images": [base64Image],
      "modifiers": ["crops_fast", "similar_images"],
      // On demande TOUS les détails possibles pour voir ce que l'API a dans le ventre
      "plant_details": [
        "common_names", 
        "url", 
        "wiki_description", 
        "taxonomy", 
        "synonyms", 
        "gbif_id", 
        "edible_parts", 
        "propagation_methods", 
        "watering", // Parfois dispo selon abonnement
        "best_light_condition", // Parfois dispo
        "best_soil_type", // Parfois dispo
        "common_uses", 
        "cultural_significance", 
        "toxicity", 
        "best_watering"
      ]
    };

    print("📡 Envoi de la requête à Plant.id...");
    
    final response = await http.post(
      Uri.parse('https://api.plant.id/v2/identify'),
      headers: {
        "Content-Type": "application/json",
        "Api-Key": apiKey,
      },
      body: jsonEncode(body),
    );

    print("📥 Réponse reçue (Code: ${response.statusCode})");
    print("---------------------------------------------------");

    if (response.statusCode == 200) {
      // Formattage du JSON pour qu'il soit lisible
      final jsonResponse = jsonDecode(response.body);
      final prettyString = const JsonEncoder.withIndent('  ').convert(jsonResponse);
      print(prettyString);
      print("---------------------------------------------------");
      print("✅ TEST TERMINÉ. Remontez pour voir tout le JSON.");
    } else {
      print("❌ ERREUR API : ${response.body}");
    }

  } catch (e) {
    print("❌ EXCEPTION : $e");
  }
}
