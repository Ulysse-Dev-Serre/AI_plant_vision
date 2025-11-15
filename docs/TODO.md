##  Architecture du Projet

```
lib/
├── main.dart                      ← PERSONNE A (navigation)
├── models/
│   └── plant.dart                 ← ENSEMBLE (modèle de données)
├── services/
│   ├── vision_api.dart            ← PERSONNE B (appel API)
│   └── storage_service.dart       ← PERSONNE B (sauvegarde)
└── screens/
    ├── camera_screen.dart         ← PERSONNE A (capture photo)
    ├── result_screen.dart         ← PERSONNE A (affichage résultat)
    └── history_screen.dart        ← PERSONNE A (liste historique)
```

##  Organisation du travail en équipe

### PERSONNE A - Interface Utilisateur (Screens)
**Branche Git :** `Screens`

- [ ] **Créer la structure des dossiers**
  ```
  lib/screens/
  lib/main.dart (navigation)
  ```

- [ ] **Écran 1 : Camera Screen** (`lib/screens/camera_screen.dart`)
  - [ ] Bouton "Prendre une photo"
  - [ ] Afficher l'aperçu de la caméra
  - [ ] Bouton "Analyser la plante"
  - [ ] Appeler la fonction `analyzerPlante()` de Personne B

- [ ] **Écran 2 : Result Screen** (`lib/screens/result_screen.dart`)
  - [ ] Afficher le nom de la plante
  - [ ] Afficher la photo prise
  - [ ] Bouton "Sauvegarder dans l'historique"
  - [ ] Bouton "Retour à la caméra"

- [ ] **Écran 3 : History Screen** (`lib/screens/history_screen.dart`)
  - [ ] Liste des plantes scannées
  - [ ] Afficher chaque plante avec sa photo + nom
  - [ ] Récupérer les données via `getHistorique()` de Personne B

- [ ] **Navigation** (`lib/main.dart`)
  - [ ] Configurer les routes entre les 3 écrans
  - [ ] Page d'accueil = Camera Screen

---

### PERSONNE B - Services & Logique Métier
**Branche Git :** `services`

- [ ] **Créer la structure des dossiers**
  ```
  lib/services/
  ```

- [ ] **Service 1 : Vision API** (`lib/services/vision_api.dart`)
  - [ ] Fonction `analyzerPlante(File image)` 
    - Envoie l'image à l'API
    - Retourne le nom de la plante
  - [ ] Gérer les erreurs (pas de connexion, API down, etc.)

- [ ] **Service 2 : Firebase Storage** (`lib/services/storage_service.dart`)
  - [ ] Configurer Firebase (console.firebase.google.com)
  - [ ] Télécharger google-services.json et GoogleService-Info.plist
  - [ ] Fonction `sauvegarderPlante(String nom, File image)`
    - Upload l'image dans Firebase Storage
    - Sauvegarder les données dans Firestore
  - [ ] Fonction `getHistorique()`
    - Lire la collection Firestore
    - Retourne la liste des plantes sauvegardées

- [ ] **Ajouter les dépendances** dans `pubspec.yaml`

---


##  Règles Git (Chacun sur sa branch)

### Personne A
```bash
git checkout -b screens
# Travaillez dans lib/screens/ et main.dart
git add lib/screens/
git commit -m "feat: ajout camera screen"
git push origin screens
```

### Personne B
```bash
git checkout -b services
# Travaillez dans lib/services/
git add lib/services/
git commit -m "feat: ajout vision api service"
git push origin services
```

---

##  Milestones (Objectifs étape par étape)

### Semaine 1 : Setup
- [ ] A : Créer les 3 écrans avec du texte de test
- [ ] B : Tester l'appel API avec Postman/curl
- [ ] Ensemble : Créer le modèle `Plant`

### Semaine 2 : Intégration
- [ ] A : Connecter les écrans aux fonctions de B
- [ ] B : Implémenter la sauvegarde locale
- [ ] Test : Prendre une photo → voir le résultat

### Semaine 3 : Finitions
- [ ] A : Améliorer le design (couleurs, icônes)
- [ ] B : Gérer les erreurs proprement
- [ ] Test : L'historique fonctionne

---


