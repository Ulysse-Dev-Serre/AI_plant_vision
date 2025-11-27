#  Documentation Technique - Services 


 **Configuration**
   - Fichier **firebase_options.dart** généré automatiquement pour supporter Android, iOS et Web.
---

##  Architecture des Services

Les 3 composants principaux :

### 1. Le Modèle de Données (lib/models/plant.dart)
- **Structure** : `nom`, `imagePath`, `imageUrl` , `date`.
- **Format** : Compatible JSON/Firestore pour la sauvegarde.

### 2. Service de Vision (lib/services/vision_api.dart)
- **Technologie** : API [Plant.id](https://web.plant.id/). 
- **Fonctionnement** :
    1. Prend un fichier image.
    2. Convertit l'image en **Base64**.
    3. Envoie une requête HTTPS sécurisée.
    4. Extrait le nom de la plante le plus probable.
- **Sécurité** : Clé API intégrée et gestion des erreurs (connexion, pas de réponse).

### 3. Service de Stockage (lib/services/storage_service.dart)
- **Technologie** : Firebase (Google).
- **Firebase Storage** : Firebase Storage était payant, donc on a choisi de sauvegarder les fichiers en local pour ce devoir.
- **Firestore Database** : Stocke les métadonnées (Nom, Date, URL de l'image).
- **Fonctionnalité clé** : `sauvegarderPlante()` gère l'upload de l'image ET l'enregistrement en base de données en une seule opération atomique.

---



## il y a trois fonctions a récupérer

**1. ANALYSE D'IMAGE**
- Fonction : analyzerPlante
- Signature : **Future<String> analyzerPlante(File imageFile)**
- Fichier : lib/services/vision_api.dart (Ligne 16)
- Description : Prend un fichier image et retourne le nom de la plante trouvé par l'API.
---

**2. SAUVEGARDE**
- Fonction : sauvegarderPlante
- Signature : **Future<void> sauvegarderPlante(String nom, File imageFile)**.
- Fichier : lib/services/storage_service.dart (Ligne 19)
- Description : Upload l'image sur Firebase et sauvegarde les infos dans la base de données.
---

**3. RECUPERATION HISTORIQUE**
- Fonction : getHistorique
- Signature : **Future<List<Plant>> getHistorique()**
- Fichier : lib/services/storage_service.dart (Ligne 55)
- Description : Retourne la liste de toutes les plantes sauvegardées, triées par date.

