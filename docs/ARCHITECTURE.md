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

**`lib/models/plant.dart`** - Fichier central partagé entre A et B, pour connaître les attributs disponibles. de nos donnée

**Attributs :**
- `String nom` : nom de la plante
- `String imagePath` : chemin de l'image sauvegardée
- `DateTime date` : date de détection

**Méthodes :** `toJson()` et `fromJson()` pour sauvegarder/lire les données

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

## Configuration Firebase

**PERSONNE B** doit configurer Firebase :

1. Créer un projet Firebase sur https://console.firebase.google.com/
2. Télécharger les fichiers de configuration :
   - Android : `google-services.json` → `android/app/`
   - iOS : `GoogleService-Info.plist` → `ios/Runner/`
3. Activer Firestore et Storage dans la console Firebase
4. Exécuter `flutter pub get`

---




