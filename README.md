# Vision Plante 🌿

API = https://web.plant.id/

Application Flutter permettant d'identifier des plantes par photo en utilisant une API de vision par ordinateur. L'application sauvegarde l'historique des plantes scannées localement.

---

## Organisation du Travail

Ce projet est développé en équipe avec une répartition claire des responsabilités :

→ [docs/TODO.md](docs/TODO.md) - Répartition des tâches et règles Git

---

##  Architecture

Structure modulaire séparant les services (logique métier) et l'interface utilisateur :

→ [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Documentation détaillée de l'architecture

→ [docs/DEPENDANCES.md](docs/DEPENDANCES.md) - Liste des dépendances et APIs

---

##  Installation et Lancement

###  Cloner le projet
```bash
git clone <url-du-repo>
cd vision_plante
```

###  Installer les dépendances

```bash
flutter pub get
```

**Trouver emulateur disponivle :**
```bash
flutter emulators
```

**Lancer emulateur exemple :**
```bash
flutter emulators --launch Pixel_8
```

**Sur émulateur Android :**
```bash
flutter run
```

---

##  Structure du Projet

```
lib/
├── main.dart              # Point d'entrée et navigation
├── models/                # Modèles de données
├── services/              # Logique métier (API, stockage)
└── screens/               # Interface utilisateur
```

---

##  Équipe

- **Meryem** : Interface utilisateur (screens)
- **Ulysse** : Services et logique métier (API, stockage)
