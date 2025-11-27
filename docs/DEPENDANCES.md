### Dépendances installées

```bash
flutter pub add http
flutter pub add cloud_firestore
flutter pub add firebase_core
flutter pub add firebase_storage
flutter pub add image_picker
```


## Liste des dépendances configurées dans `pubspec.yaml`.

**`http: ^1.1.0`**  
Pour effectuer les requêtes HTTP vers l'API de reconnaissance de plantes.

**`cloud_firestore: ^5.0.0`**  
Pour sauvegarder l'historique des plantes dans Firebase Firestore (base de données cloud).

**`firebase_core: ^3.0.0`**  
Configuration de base de Firebase (obligatoire pour utiliser Firebase).

**`firebase_storage: ^12.0.0`**  
Pour stocker les images des plantes dans Firebase Storage (stockage cloud).

**`image_picker: ^1.0.7`**  
Pour accéder à la caméra et prendre des photos des plantes.

---

## API de Vision 

### Plant.id (Recommandé) ✅
- Gratuit : 100 requêtes/mois 
- Très précis pour la reconnaissance de plantes
- https://plant.id/ 
 

 ---

### Pl@ntNet
- Gratuit : 500 requêtes/jour
- Open source, base de données communautaire
- https://my.plantnet.org/

### Google Cloud Vision
- Gratuit : 1000 requêtes/mois
- Reconnaissance générale (pas spécialisé plantes)
- https://cloud.google.com/vision
