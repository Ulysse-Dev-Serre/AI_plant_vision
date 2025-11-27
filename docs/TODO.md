

##  Organisation du travail en équipe

### PERSONNE A - Interface Utilisateur (Screens) --  Meryem
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
  - [ ] Bouton "Nouvelle analyse"  

- [ ] **Écran 3 : History Screen** (`lib/screens/history_screen.dart`)
  - [ ] Liste des plantes scannées
  - [ ] Afficher chaque plante avec sa photo + nom
  - [ ] Récupérer les données via `getHistorique()` de Personne B

- [ ] **Navigation** (`lib/main.dart`)
  - [ ] Configurer les routes entre les 3 écrans
  - [ ] Page d'accueil = Camera Screen

---

### PERSONNE B - Services & Logique Métier -- Ulysse
**Branche Git :** `services`

- [ ] **Créer la structure des dossiers**
  ```
  lib/services/
  ```

- [ ] **Service 1 : Vision API** (`lib/services/vision_api.dart`)
  - [ ] Fonction `analyzerPlante(File image)` 
    - Envoie l'image à l'API
    - Retourne le nom et detail de la plante 
  - [ ] Gérer les erreurs (pas de connexion, API down, etc.)

- [ ] **Service 2 : Firebase Storage** (`lib/services/storage_service.dart`)
  - [ ] Configurer Firebase (console.firebase.google.com)
  - [ ] Télécharger google-services.json et GoogleService-Info.plist
  - [ ] Fonction `sauvegarderPlante(String nom, File image)`
    - Upload l'image dans Firebase Storage  (PAS FAIT) on Upload en local
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




