# Architecture - Vision Plante 

 comment les différents fichiers du projet interagissent entre eux.

## Structure des Dossiers

```
lib/
├── main.dart                      ← PERSONNE A
├── models/
│   └── plant.dart                 ← ENSEMBLE
├── services/
│   ├── vision_api.dart            ← PERSONNE B
│   └── storage_service.dart       ← PERSONNE B
└── screens/
    ├── camera_screen.dart         ← PERSONNE A
    ├── result_screen.dart         ← PERSONNE A
    └── history_screen.dart        ← PERSONNE A
```

## ENSEMBLE - Modèle de Données

**`lib/models/plant.dart`** - Fichier central partagé entre A et B

pour connaître les attributs disponibles. de nos donnée

**Attributs :**
- `String nom` : nom de la plante
- `String imagePath` : chemin de l'image sauvegardée
- `DateTime date` : date de détection

**Méthodes :** `toJson()` et `fromJson()` pour sauvegarder/lire les données

**Important :** Toute modification doit être discutée ensemble.

---

## Flux de Données

### Scénario 1 : Analyser une nouvelle plante

```
1. User ouvre l'app
   → main.dart lance CameraScreen (PERSONNE A)

2. User clique "Prendre une photo"
   → camera_screen.dart utilise ImagePicker (PERSONNE A)
   
3. User clique "Analyser"
   → camera_screen.dart appelle vision_api.dart (PERSONNE B)
   → vision_api.dart envoie l'image à l'API externe
   → vision_api.dart retourne "Monstera Deliciosa"
   
4. camera_screen.dart navigue vers result_screen.dart (PERSONNE A)
   → result_screen.dart affiche "Monstera Deliciosa" + image
   
5. User clique "Sauvegarder"
   → result_screen.dart appelle storage_service.dart (PERSONNE B)
   → storage_service.dart upload l'image dans Firebase Storage
   → storage_service.dart sauvegarde les données dans Firestore
```

### Scénario 2 : Consulter l'historique

```
1. User clique sur l'icône historique
   → camera_screen.dart navigue vers history_screen.dart (PERSONNE A)
   
2. history_screen.dart charge les données
   → Appelle storage_service.getHistorique() (PERSONNE B)
   → storage_service.dart lit les données de Firestore
   → Retourne List<Plant>
   
3. history_screen.dart affiche la liste (PERSONNE A)
```

---

## Contrat entre Personne A et Personne B

### Ce que Personne B DOIT fournir à Personne A

```dart
// Dans vision_api.dart
class VisionApiService {
  Future<String> analyzerPlante(File image);
}

// Dans storage_service.dart
class StorageService {
  Future<void> sauvegarderPlante(String nom, File image);
  Future<List<Plant>> getHistorique();
}
```

### Ce que Personne A peut utiliser

- Personne A peut importer et utiliser ces services même si les fonctions ne sont pas encore complètes
- Personne A peut tester avec des données fictives en attendant

---

## Configuration Firebase

**PERSONNE B** doit configurer Firebase :

1. Créer un projet Firebase sur https://console.firebase.google.com/
2. Télécharger les fichiers de configuration :
   - Android : `google-services.json` → `android/app/`
   - iOS : `GoogleService-Info.plist` → `ios/Runner/`
3. Activer Firestore et Storage dans la console Firebase
4. Exécuter `flutter pub get`

---

## Règles de Collaboration
**Communiquer les changements** dans le modèle `Plant` (fichier partagé)


---

## Questions Fréquentes

**Q: Personne A peut-elle commencer sans que Personne B ait fini ?**  
R: Oui ! Les fichiers squelettes contiennent des `throw UnimplementedError()`. Personne A peut construire l'UI et tester la navigation.

**Q: Comment tester sans l'API ?**  
R: Personne B peut temporairement retourner `"Test Plant"` au lieu d'appeler l'API.

**Q: Qui crée le fichier `plant.dart` ?**  
R: Le fichier existe déjà (créé ensemble). Si besoin de modifications, discutez-en à deux.

---


