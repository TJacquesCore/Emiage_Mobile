# Structure du Projet - EMIAGE App

## Architecture Modulaire

Le projet a été décomposé en plusieurs fichiers pour une meilleure organisation et maintenabilité.

### Structure des Répertoires

```
lib/
├── main.dart                 # Point d'entrée principal (MyApp, MyHomePage)
├── main_old.dart             # Ancienne version monolithique (archivée)
├── screens/                  # Écrans de l'application
│   ├── tab_screen.dart       # Accueil (Dashboard)
│   ├── cours_screen.dart     # Écran Cours
│   ├── informations_screen.dart  # Publications & Favoris
│   ├── planning_screen.dart  # Emploi du temps principal
│   ├── plats_screen.dart     # Restaurant Edmon
│   ├── settings_screen.dart  # Paramètres utilisateur
│   ├── mes_cours_screen.dart # Détail des cours (Demo)
│   ├── planning_demo_screen.dart # Détail planning (Demo)
│   └── messages_demo_screen.dart # Détail messages (Demo)
└── widgets/
    └── shared_widgets.dart   # Composants réutilisables
```

## Fichiers Clés

### main.dart
- **Responsabilités**: Application root, thème, navigation
- **Contient**: 
  - `MyApp`: Configuration du thème (light/dark mode)
  - `MyHomePage`: Navigation entre les 6 onglets
  - `darkModeNotifier`: ValueNotifier pour le mode sombre global

### screens/

#### tab_screen.dart
- **Accueil/Dashboard** avec statistiques et accès rapide
- Affiche 4 cards (Cours, Événements, Annonces, Offres)
- Boutons d'accès rapide vers Mes Cours, Emploi du temps, Messages

#### cours_screen.dart
- Affichage des cours disponibles
- (À compléter avec les données des cours)

#### informations_screen.dart
- Publications avec filtrage par type
- Onglet Favoris
- Icônes colorées par type de publication
- Détails des publications en modal

#### planning_screen.dart
- Emploi du temps principal de l'utilisateur

#### plats_screen.dart
- Restaurant Edmon
- Menu avec 5 plats
- Système de panier
- Intégration WhatsApp pour commander

#### settings_screen.dart
- Profil utilisateur
- Informations personnelles
- Mode sombre toggle
- Paramètres de notification
- Sélection de langue
- Paramètres de sécurité
- Bouton déconnexion

#### mes_cours_screen.dart
- Détail des cours de l'utilisateur
- Progression, notes, ECTS

#### planning_demo_screen.dart
- Détail du planning avec filtrage par jour

#### messages_demo_screen.dart
- Affichage des messages
- Filtrage par priorité

### widgets/shared_widgets.dart
**Composants réutilisables**:
- `DashboardCard`: Carte statistique avec titre, valeur, icône
- `QuickAccessButton`: Bouton d'accès rapide avec sous-titre
- `ProfileInfoTile`: Ligne d'information profil (clé-valeur)

## Thème et Couleurs

- **Couleur primaire**: Deep Purple
- **Mode clair**: Light theme avec Material 3
- **Mode sombre**: Dark theme avec Material 3
- **Gestion globale**: `darkModeNotifier` (ValueNotifier)

## Navigation

- **Bottom Navigation Bar** avec 6 onglets
- **Nested navigation** pour les sous-écrans (Navigator.push)
- Routes principales:
  1. Accueil (TabScreen)
  2. Cours (CoursScreen)
  3. Informations (InformationsScreen)
  4. Planning (PlanningScreen)
  5. Plats (PlatsScreen)
  6. Paramètres (SettingsScreen)

## État et Gestion

- **État local**: `StatefulWidget` + `setState()`
- **État global**: `ValueNotifier` pour le mode sombre
- **Publications**: Liste en mémoire dans `MyHomePage`

## Packages Utilisés

- `flutter/material.dart`: Framework UI
- `url_launcher`: Intégration WhatsApp pour les commandes

## Prochaines Étapes

Pour continuer le développement:
1. Remplir les screens avec les données réelles/demo
2. Ajouter une base de données local (Hive, SQLite)
3. Implémenter les API backend
4. Ajouter des tests unitaires et d'intégration
5. Optimiser les performances
