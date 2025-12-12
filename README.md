# 🌿 Vision Plante


![Capture d'écran de l'application](/docs/image.png)

---

##  Description

### À quoi sert l'application ?

**Vision Plante** est une application mobile Flutter qui permet d'identifier des plantes à partir d'une simple photo. Grâce à l'intelligence artificielle (API Plant.id), l'application analyse l'image et retourne le nom scientifique, les noms communs et une description détaillée de la plante.

### Fonctionnalités principales

-  **Capture photo** : Prenez une photo avec la caméra ou sélectionnez depuis la galerie
-  **Identification IA** : Analyse automatique via l'API Plant.id
-  **Résultats détaillés** : Nom scientifique, noms communs, description Wikipedia, taux de confiance
-  **Sauvegarde** : Enregistrement des plantes identifiées dans Firebase Firestore
-  **Historique** : Consultez toutes vos plantes analysées avec leurs détails complets

### Public cible

- Amateurs de jardinage et botanistes
- Étudiants en biologie ou botanique
- Curieux de la nature souhaitant identifier les plantes qu'ils rencontrent

---

##  Architecture MVVM

L'application suit une architecture **inspirée du pattern MVVM** (Model-View-ViewModel) adaptée à Flutter, avec une séparation claire des responsabilités.

### Diagramme de l'architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         VIEWS (Screens)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │CameraScreen │  │ResultScreen │  │HistoryScreen│              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
└─────────┼────────────────┼────────────────┼─────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SERVICES (ViewModels/Providers)              │
│  ┌──────────────────┐      ┌──────────────────┐                 │
│  │  VisionApiService│      │  StorageService  │                 │
│  │  (API Plant.id)  │      │  (Firebase)      │                 │
│  └──────────────────┘      └──────────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
          │                          │
          ▼                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                         MODELS                                  │
│                    ┌──────────────┐                             │
│                    │    Plant     │                             │
│                    └──────────────┘                             │
└─────────────────────────────────────────────────────────────────┘
```

### Structure des dossiers

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── firebase_options.dart        # Configuration Firebase
├── models/
│   └── plant.dart               # Modèle de données Plant
├── services/
│   ├── vision_api.dart          # Service d'appel API Plant.id
│   └── storage_service.dart     # Service de persistance Firebase
├── screens/
│   ├── camera_screen.dart       # Écran principal (capture photo)
│   ├── result_screen.dart       # Écran de résultat d'analyse
│   └── history_screen.dart      # Écran d'historique
└── utils/
    └── app_logger.dart          # Utilitaire de logging
```

### Rôle de chaque dossier

| Dossier | Rôle | Pattern |
|---------|------|---------|
| `models/` | Définition des structures de données (Plant) | **Model** |
| `services/` | Logique métier, appels API, persistance | **ViewModel/Provider** |
| `screens/` | Interface utilisateur, widgets Flutter | **View** |
| `utils/` | Utilitaires partagés (logging, helpers) | Helpers |

### Communication entre les composants

1. **View → Service** : Les écrans appellent les services pour effectuer des actions (analyser, sauvegarder)
2. **Service → Model** : Les services créent et manipulent les objets Plant
3. **Service → View** : Les services retournent des données aux écrans via des Futures

---

##  Installation et lancement

### Prérequis

- Flutter SDK 3.10+
- Dart SDK 3.10+
- Un compte Firebase (pour Firestore)
- Une clé API Plant.id

### Étapes d'installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/Ulysse-Dev-Serre/AI_plant_vision.git
   cd AI_plant_vision
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer les variables d'environnement**
   
   Créez un fichier `.env` à la racine du projet :
   ```env
   PLANT_ID_API_KEY=votre_cle_api_plant_id
   ```

4. **Configurer Firebase**
   - Créez un projet sur [Firebase Console](https://console.firebase.google.com/)
   - Téléchargez `google-services.json` et placez-le dans `android/app/`
   - Activez Firestore dans la console Firebase

5. **Lancer l'application**
   ```bash
   flutter run
   ```

---

##  Fonctionnement

### Comment utiliser l'application ?

1. **Ouvrir l'app** → L'écran principal s'affiche avec le message "Identifiez votre plante en un clic"

2. **Prendre/Sélectionner une photo**
   - Cliquez sur "Caméra" pour prendre une photo
   - Ou cliquez sur "Galerie" pour sélectionner une image existante

3. **Analyser la plante**
   - Une fois l'image chargée, cliquez sur "Analyser la plante"
   - L'IA analyse l'image et retourne les résultats

4. **Consulter les résultats**
   - Nom scientifique avec taux de confiance
   - Noms communs
   - Description Wikipedia
   - Probabilité que ce soit une plante

5. **Sauvegarder** → Cliquez sur "Sauvegarder" pour enregistrer dans l'historique

6. **Consulter l'historique** → Cliquez sur l'icône horloge en haut à droite

### Navigation entre les écrans

```
┌──────────────┐     Analyser     ┌──────────────┐
│ CameraScreen │ ───────────────► │ ResultScreen │
│  (Accueil)   │                  │  (Résultat)  │
└──────┬───────┘ ◄─────────────── └──────────────┘
       │              Retour            │
       │                                │ Sauvegarder
       │ Historique                     ▼
       ▼                         ┌──────────────┐
┌──────────────┐                 │   Firebase   │
│HistoryScreen │ ◄───────────────│  Firestore   │
│ (Historique) │    Lecture      └──────────────┘
└──────────────┘
```

### Fonctionnalités clés

| Fonctionnalité | Description |
|----------------|-------------|
|  Identification | Reconnaissance par IA avec Plant.id API |
|  Confiance | Pourcentage de fiabilité de l'identification |
|  Wiki | Description détaillée depuis Wikipedia |
|  Persistance | Sauvegarde locale + Cloud (Firebase) |
|  Suppression | Possibilité de supprimer de l'historique |

---

##  Équipe

| Membre | Rôle | Responsabilités |
|--------|------|-----------------|
| **[Meryem]** | Développeur Frontend | UI/UX, Écrans (camera, result, history), Navigation |
| **[Ulysse]** | Développeur Backend | API Vision, Firebase, Services de données |

### Répartition des tâches

**Meryem:**
- `main.dart` - Point d'entrée et configuration
- `screens/camera_screen.dart` - Écran de capture
- `screens/result_screen.dart` - Écran de résultats
- `screens/history_screen.dart` - Écran d'historique

**Ulysse :**
- `services/vision_api.dart` - Intégration API Plant.id
- `services/storage_service.dart` - Persistance Firebase
- Configuration Firebase
- `models/plant.dart` - Modèle de données partagé

---

##  Technologies utilisées

### Framework et langage

| Technologie | Version |
|-------------|---------|
| Flutter | 3.10+ |
| Dart | 3.10+ |

### Packages Flutter

| Package | Version | Utilisation |
|---------|---------|-------------|
| `firebase_core` | ^3.0.0 | Initialisation Firebase |
| `cloud_firestore` | ^5.0.0 | Base de données Cloud |
| `image_picker` | ^1.0.7 | Capture photo / Galerie |
| `http` | ^1.1.0 | Appels API REST |
| `flutter_dotenv` | ^5.2.1 | Variables d'environnement |
| `path_provider` | ^2.0.15 | Accès au système de fichiers |
| `intl` | ^0.19.0 | Formatage des dates |
| `path` | ^1.9.1 | Manipulation des chemins |

### Services externes

| Service | Utilisation |
|---------|-------------|
| **Plant.id API** | Identification des plantes par IA |
| **Firebase Firestore** | Base de données NoSQL Cloud |



