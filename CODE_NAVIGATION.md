# 📖 Guide de Navigation du Code - EMIAGE App

## 🗺️ Trouver rapidement ce que tu cherches

### Je veux modifier l'écran d'accueil
→ Fichier: `lib/screens/tab_screen.dart`
- Contient: Bienvenue, Statistiques, Accès rapide
- Utilise: DashboardCard, QuickAccessButton

### Je veux ajouter/modifier les cours
→ Fichier: `lib/screens/cours_screen.dart`
- Affiche la liste des cours
- À compléter avec les données réelles

### Je veux modifier les publications/favoris
→ Fichier: `lib/screens/informations_screen.dart`
- Gère les publications et les favoris
- Contient la logique de filtrage
- Affiche les détails en modal

### Je veux modifier le planning
→ Fichier: `lib/screens/planning_screen.dart` (ou planning_demo_screen.dart pour les détails)
- Emploi du temps principal
- Navigation vers les détails

### Je veux modifier la commande de plats
→ Fichier: `lib/screens/plats_screen.dart`
- Menu du restaurant Edmon
- Système de panier
- Intégration WhatsApp

### Je veux modifier les paramètres
→ Fichier: `lib/screens/settings_screen.dart`
- Profil utilisateur
- Mode sombre
- Notifications
- Sécurité

### Je veux modifier les composants réutilisables
→ Fichier: `lib/widgets/shared_widgets.dart`
- DashboardCard
- QuickAccessButton
- ProfileInfoTile

### Je veux modifier la navigation ou le thème global
→ Fichier: `lib/main.dart`
- MyApp (Configuration du thème)
- MyHomePage (Navigation)
- darkModeNotifier (État global du mode sombre)

---

## 🔑 Points de Personnalisation Clés

### Changer la couleur primaire
```dart
// Dans main.dart, MyApp.build()
ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,  // ← Changer ici
)
```

### Ajouter une nouvelle publication demo
```dart
// Dans informations_screen.dart
final List<Map<String, String>> _publicationsDemo = [
  // Ajouter ici...
];
```

### Ajouter un nouveau plat
```dart
// Dans plats_screen.dart
final List<Map<String, dynamic>> plats = [
  // Ajouter ici...
];
```

### Activer/Désactiver le mode sombre par défaut
```dart
// Dans main.dart
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);  // false = light, true = dark
```

---

## 📊 Statistiques du Code

| Aspect | Avant | Après |
|--------|-------|-------|
| Fichiers | 1 (main.dart 3600+ lignes) | 12 fichiers modulaires |
| main.dart | 3600+ lignes | ~65 lignes |
| Maintenabilité | ❌ Difficile | ✅ Facile |
| Tests | ❌ Impossible | ✅ Possible |
| Collaboration | ❌ Conflits probables | ✅ Travail parallèle |

---

## 🎯 Structure des Imports

```
main.dart
  ├── screens/tab_screen.dart
  │   ├── widgets/shared_widgets.dart
  │   └── screens/[demo_screens]
  ├── screens/cours_screen.dart
  ├── screens/informations_screen.dart
  ├── screens/planning_screen.dart
  ├── screens/plats_screen.dart
  └── screens/settings_screen.dart
```

---

## ✅ Vérification d'une Modification

Après avoir modifié un fichier:

1. **Vérifier la syntaxe**: `flutter analyze`
2. **Compiler**: `flutter build apk` ou `flutter run`
3. **Tester l'écran modifié** en appuyant sur le bon onglet

---

**Besoin d'aide?** Consulte les fichiers `.md` dans le répertoire racine du projet.
