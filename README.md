# Vision Plante 🌿

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

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd vision_plante
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer l'application

**Sur émulateur Android :**
```bash
flutter run
```

**Sur navigateur web :**
```bash
flutter run -d chrome
```

**Sur Windows :**
```bash
flutter run -d windows
```

### 4. Vérifier que tout fonctionne

```bash
flutter doctor
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

- **Personne A** : Interface utilisateur (screens)
- **Personne B** : Services et logique métier (API, stockage)
