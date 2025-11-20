import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vision_plante/services/vision_api.dart';
import 'package:vision_plante/services/storage_service.dart';

// NOTE: Ce test est un test d'intégration manuel.
// Il ne peut pas être lancé par "flutter test" classique car il a besoin 
// de dépendances réelles (Internet, Firebase) qui ne sont pas mockées ici.
//
// Cependant, pour valider votre code RAPIDEMENT, c'est un bon script.

void main() {
  test('Test Manuel des Services', () async {
    print('--- DÉBUT DU TEST MANUEL ---');

    // 1. Préparation de l'image de test
    final File imageFile = File('test_assets/plant_test2.jpg');
    if (!await imageFile.exists()) {
      print('ERREUR: L\'image de test n\'existe pas.');
      return;
    }
    print('✅ Image de test trouvée : ${imageFile.path}');

    // 2. Test du VisionApiService
    print('\n--- Test Vision API ---');
    final visionService = VisionApiService();
    
    print('Envoi de l\'image à Plant.id...');
    final resultat = await visionService.analyzerPlante(imageFile);
    
    print('RÉSULTAT API : $resultat');
    
    if (resultat != "Erreur de connexion" && resultat != "Configuration API manquante") {
      print('✅ API Vision semble fonctionner (réponse reçue)');
    } else {
      print('❌ Problème avec l\'API Vision');
    }

    // 3. Test du StorageService (Firebase)
    // ATTENTION : Cela nécessite que Firebase soit initialisé, ce qui est compliqué
    // dans un script de test pur sans lancer l'app complète.
    // Pour tester Firebase Storage, il vaut mieux lancer l'app.
    
    print('\n--- Test Storage (Simulé) ---');
    print('⚠️ Le test réel de Firebase nécessite un environnement Flutter complet (émulateur/device).');
    print('Pour tester StorageService, intégrez-le dans l\'UI ou lancez un test d\'intégration driver.');

    print('\n--- FIN DU TEST ---');
  });
}
