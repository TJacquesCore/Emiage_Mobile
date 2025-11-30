import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ValueNotifier global pour le mode sombre
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'Bottom Navigation Tabs',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(title: 'Mon Application'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _publications = [];

  @override
  void initState() {
    super.initState();
  }

  void _ajouterPublication(Map<String, String> nouvellePublication) {
    setState(() {
      _publications.add(nouvellePublication);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const TabScreen(title: 'Accueil', icon: Icons.home);
      case 1:
        return const CoursScreen(title: 'Cours', icon: Icons.school);
      case 2:
        return InformationsScreen(
          title: 'Informations',
          icon: Icons.info,
          publications: _publications,
          onRefresh: () {
            setState(() {});
          },
        );
      case 3:
        return const PlanningScreen(title: 'Planning', icon: Icons.calendar_today);
      case 4:
        return const PlatsScreen(title: 'Plats', icon: Icons.restaurant);
      case 5:
        return const SettingsScreen(title: 'Paramètres', icon: Icons.settings);
      default:
        return const TabScreen(title: 'Accueil', icon: Icons.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _getScreen(_selectedIndex),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PostInformationScreen(),
                  ),
                ).then((result) {
                  if (result != null && result is Map<String, String>) {
                    _ajouterPublication(result);
                  }
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Plats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class TabScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const TabScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de bienvenue
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.waving_hand,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Bienvenue !',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Découvrez les dernières informations et mises à jour',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Section Statistiques
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vous avez 12 cours actifs'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: DashboardCard(
                      icon: Icons.book,
                      title: 'Cours',
                      value: '12',
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('5 événements à venir'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: DashboardCard(
                      icon: Icons.event,
                      title: 'Événements',
                      value: '5',
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('8 annonces disponibles'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: DashboardCard(
                      icon: Icons.info,
                      title: 'Annonces',
                      value: '8',
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('3 offres d\'emploi'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: DashboardCard(
                      icon: Icons.work,
                      title: 'Offres',
                      value: '3',
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Section Accès rapide
            Text(
              'Accès rapide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MesCoursDemoScreen(),
                  ),
                );
              },
              child: QuickAccessButton(
                icon: Icons.book_outlined,
                title: 'Mes cours',
                subtitle: 'Consultez vos cours',
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlanningDemoScreen(),
                  ),
                );
              },
              child: QuickAccessButton(
                icon: Icons.calendar_today,
                title: 'Emploi du temps',
                subtitle: 'Votre planning',
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MessagesDemoScreen(),
                  ),
                );
              },
              child: QuickAccessButton(
                icon: Icons.mail,
                title: 'Messages',
                subtitle: 'Consultez vos messages',
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const QuickAccessButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
        ],
      ),
    );
  }
}

class InformationsScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Map<String, String>> publications;
  final VoidCallback onRefresh;

  const InformationsScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.publications,
    required this.onRefresh,
  });

  @override
  State<InformationsScreen> createState() => _InformationsScreenState();
}

class _InformationsScreenState extends State<InformationsScreen> {
  String _selectedFilter = 'Tous';
  String _currentTab = 'publications'; // 'publications' ou 'favoris'
  final List<String> _filterOptions = ['Tous', 'Annonce', 'Événement', 'Information', 'Offre d\'emploi'];
  final Set<int> _favorites = {0, 2}; // Index des favoris par défaut

  // Données pré-définies (demo)
  final List<Map<String, String>> _publicationsDemo = [
    {
      'titre': 'Réunion d\'orientation',
      'contenu': 'Réunion importante concernant l\'orientation pédagogique de la formation. Venez nombreux !',
      'type': 'Annonce',
      'date': '2025-11-28',
      'auteur': 'Admin',
    },
    {
      'titre': 'Conférence Flutter avancé',
      'contenu': 'Conférence sur les patterns avancés en Flutter avec des experts du domaine.',
      'type': 'Événement',
      'date': '2025-11-27',
      'auteur': 'Département Informatique',
    },
    {
      'titre': 'Mise à jour du système académique',
      'contenu': 'Le système académique a été mis à jour avec de nouvelles fonctionnalités.',
      'type': 'Information',
      'date': '2025-11-26',
      'auteur': 'Support IT',
    },
    {
      'titre': 'Stage - Google France',
      'contenu': 'Opportunité de stage chez Google France. Postulez avant le 15 décembre.',
      'type': 'Offre d\'emploi',
      'date': '2025-11-25',
      'auteur': 'Ressources Humaines',
    },
    {
      'titre': 'Amphi reporté',
      'contenu': 'L\'amphi du 29 novembre est reporté au 30 novembre à 10h.',
      'type': 'Annonce',
      'date': '2025-11-24',
      'auteur': 'Admin',
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPubs = [..._publicationsDemo, ...widget.publications];
    List<Map<String, String>> displayedPubs;
    
    if (_currentTab == 'favoris') {
      displayedPubs = _favorites
          .where((i) => i < allPubs.length)
          .map((i) => allPubs[i])
          .toList();
    } else {
      displayedPubs = _selectedFilter == 'Tous'
          ? allPubs
          : allPubs.where((pub) => pub['type'] == _selectedFilter).toList();
    }

    return Column(
      children: [
        // En-tête
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 50,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Onglets Publications/Favoris
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTab = 'publications';
                      _selectedFilter = 'Tous';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _currentTab == 'publications'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Publications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _currentTab == 'publications'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _currentTab == 'publications'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTab = 'favoris';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _currentTab == 'favoris'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Favoris (${_favorites.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _currentTab == 'favoris'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _currentTab == 'favoris'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Filtres (uniquement si on est sur Publications)
        if (_currentTab == 'publications')
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: _filterOptions.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'Tous';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        if (_currentTab == 'publications') const SizedBox(height: 15),
        // Liste des informations
        Expanded(
          child: displayedPubs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentTab == 'favoris' ? Icons.favorite_outline : Icons.info_outline,
                        size: 80,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]
                            : Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentTab == 'favoris' ? 'Aucun favori' : 'Aucune information',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: displayedPubs.length,
                  itemBuilder: (context, index) {
                    final pub = displayedPubs[index];
                    final pubIndex = allPubs.indexOf(pub);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          _showPublicationDetails(context, pub);
                        },
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            leading: _getTypeIcon(pub['type'] ?? ''),
                            title: Text(
                              pub['titre'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pub['contenu'] != null && pub['contenu']!.length > 50
                                      ? '${pub['contenu']!.substring(0, 50)}...'
                                      : pub['contenu'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Par ${pub['auteur'] ?? 'Auteur inconnu'}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _favorites.contains(pubIndex)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favorites.contains(pubIndex)
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite(pubIndex);
                                  },
                                ),
                                Chip(
                                  label: Text(pub['type'] ?? ''),
                                  backgroundColor: _getTypeColor(pub['type'] ?? ''),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _getTypeIcon(String type) {
    switch (type) {
      case 'Annonce':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.campaign, color: Colors.white),
        );
      case 'Événement':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event, color: Colors.white),
        );
      case 'Information':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.info, color: Colors.white),
        );
      case 'Offre d\'emploi':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.work, color: Colors.white),
        );
      default:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.info, color: Colors.white),
        );
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Annonce':
        return Colors.blue;
      case 'Événement':
        return Colors.green;
      case 'Information':
        return Colors.orange;
      case 'Offre d\'emploi':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showPublicationDetails(BuildContext context, Map<String, String> pub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pub['titre'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(pub['type'] ?? ''),
                    backgroundColor: _getTypeColor(pub['type'] ?? ''),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    pub['date'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Auteur: ${pub['auteur'] ?? 'Inconnu'}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Contenu:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(pub['contenu'] ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Publication ajoutée aux favoris'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Ajouter aux favoris'),
          ),
        ],
      ),
    );
  }
}

class PostInformationScreen extends StatefulWidget {
  const PostInformationScreen({super.key});

  @override
  State<PostInformationScreen> createState() => _PostInformationScreenState();
}

class _PostInformationScreenState extends State<PostInformationScreen> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  String? _fichierSelectionne;
  String _typePublication = 'Information';

  final List<String> _typesPublication = [
    'Annonce',
    'Événement',
    'Information',
    'Offre d\'emploi'
  ];

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Poster une Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre avec Dropdown
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Titre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _titreController,
                        decoration: InputDecoration(
                          hintText: 'Entrez le titre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.title),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _typePublication,
                        isExpanded: true,
                        items: _typesPublication.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              _typePublication = newValue;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Champ Contenu
            const Text(
              'Contenu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contenuController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Rédigez le contenu de l\'information',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 15),
            // Bouton Joindre un fichier
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _fichierSelectionne = 'document.pdf';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fichier sélectionné : document.pdf'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Joindre un fichier'),
              ),
            ),
            if (_fichierSelectionne != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _fichierSelectionne!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _fichierSelectionne = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titreController.text.isEmpty ||
                          _contenuController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Veuillez remplir tous les champs requis'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        final publication = {
                          'titre': _titreController.text,
                          'contenu': _contenuController.text,
                          'type': _typePublication,
                          if (_fichierSelectionne != null)
                            'fichier': _fichierSelectionne!,
                        };
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Information postée avec succès !'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).pop(publication);
                      }
                    },
                    child: const Text('Publier'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CoursScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const CoursScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<CoursScreen> createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  final List<Map<String, dynamic>> coursesData = [
    {
      'niveau': 'L1',
      'nbCours': 8,
      'progression': 70,
      'cours': [
        'Algorithme et Structures de données',
        'Programmation Python',
        'Mathématiques Discrètes',
        'Physique',
      ]
    },
    {
      'niveau': 'L2',
      'nbCours': 10,
      'progression': 75,
      'cours': [
        'Programmation Orientée Objet',
        'Bases de Données',
        'Réseaux Informatiques',
        'Système d\'Exploitation',
      ]
    },
    {
      'niveau': 'L3',
      'nbCours': 12,
      'progression': 80,
      'cours': [
        'Développement Web',
        'Architecture Logicielle',
        'Intelligence Artificielle',
        'Programmation Mobile',
      ]
    },
    {
      'niveau': 'Master 1',
      'nbCours': 15,
      'progression': 85,
      'cours': [
        'Machine Learning Avancé',
        'Cloud Computing',
        'Sécurité Informatique',
        'Développement Android',
      ]
    },
    {
      'niveau': 'Master 2',
      'nbCours': 14,
      'progression': 90,
      'cours': [
        'Projet de Recherche',
        'Blockchain',
        'DevOps et Kubernetes',
        'Développement Flutter',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // En-tête
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 50,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Liste des niveaux
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: coursesData.length,
            itemBuilder: (context, index) {
              final data = coursesData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Niveau ${data['niveau']}'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Nombre de cours: ${data['nbCours']}'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${data['progression']}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  value: data['progression'] / 100,
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Cours disponibles:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ...((data['cours'] as List).map((cours) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(cours as String)),
                                    ],
                                  ),
                                );
                              }).toList()),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fermer'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Accès aux cours du niveau ${data['niveau']}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Voir les cours'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            data['niveau'],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        'Niveau ${data['niveau']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['nbCours']} cours disponibles',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: data['progression'] / 100,
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlanningScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlanningScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> semaineEDT = [
      {
        'jour': 'Lundi 25 Nov',
        'cours': [
          {'heure': '09:00 - 10:30', 'nom': 'Programmation Dart', 'salle': 'A101'},
          {'heure': '11:00 - 12:30', 'nom': 'Bases de données', 'salle': 'B205'},
          {'heure': '14:00 - 15:30', 'nom': 'Architecture Logicielle', 'salle': 'A101'},
        ]
      },
      {
        'jour': 'Mardi 26 Nov',
        'cours': [
          {'heure': '08:00 - 09:30', 'nom': 'Réseaux Informatiques TP', 'salle': 'C310'},
          {'heure': '10:00 - 11:30', 'nom': 'Sécurité Informatique', 'salle': 'B205'},
        ]
      },
      {
        'jour': 'Mercredi 27 Nov',
        'cours': [
          {'heure': '09:00 - 10:30', 'nom': 'Web Development', 'salle': 'D405'},
          {'heure': '13:00 - 14:30', 'nom': 'Séminaire Flutter', 'salle': 'A101'},
          {'heure': '15:00 - 16:30', 'nom': 'Mobile App Dev', 'salle': 'B205'},
        ]
      },
      {
        'jour': 'Jeudi 28 Nov',
        'cours': [
          {'heure': '10:00 - 11:30', 'nom': 'Algorithme Avancé', 'salle': 'C310'},
          {'heure': '14:00 - 15:30', 'nom': 'Projet Pratique', 'salle': 'D405'},
        ]
      },
      {
        'jour': 'Vendredi 29 Nov',
        'cours': [
          {'heure': '08:00 - 10:00', 'nom': 'Programmation Dart', 'salle': 'A101'},
          {'heure': '10:30 - 12:00', 'nom': 'Bases de données', 'salle': 'B205'},
          {'heure': '13:00 - 14:30', 'nom': 'Réseaux Informatiques', 'salle': 'C310'},
          {'heure': '15:00 - 16:30', 'nom': 'Architecture Logicielle', 'salle': 'A101'},
          {'heure': '17:00 - 18:00', 'nom': 'Séminaire Flutter', 'salle': 'D405'},
        ]
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // En-tête
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Semaine du 25 au 29 Novembre 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Emploi du temps de la semaine
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: semaineEDT.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> jour = entry.value;
                bool isTodayFriday = index == 4;

                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isTodayFriday
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300]!,
                        width: isTodayFriday ? 2 : 1,
                      ),
                      boxShadow: isTodayFriday
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        // En-tête du jour
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isTodayFriday
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(11),
                              topRight: Radius.circular(11),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                jour['jour'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isTodayFriday
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              if (isTodayFriday)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Aujourd\'hui',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Cours du jour
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (jour['cours'] as List)
                                .asMap()
                                .entries
                                .map((courseEntry) {
                              int courseIndex = courseEntry.key;
                              Map<String, String> course =
                                  courseEntry.value;
                              bool isLast = courseIndex ==
                                  (jour['cours'] as List).length - 1;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: isLast ? 0 : 12,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(course['nom'] ?? ''),
                                        content: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.schedule, color: Colors.blue),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Horaire: ${course['heure']!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on, color: Colors.red),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Salle: ${course['salle']!}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            const Text(
                                              'Enseignant: Prof. Dupont',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            const Text(
                                              'Capacité: 30/35 étudiants',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Fermer'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Cours ajouté au calendrier'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ajouter au calendrier'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        padding:
                                            const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          course['heure']!,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          textAlign:
                                              TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              course['nom'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .location_on,
                                                  size: 12,
                                                  color: Colors
                                                      .grey[500],
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  'Salle ${course['salle']!}',
                                                  style:
                                                      TextStyle(
                                                    fontSize:
                                                        11,
                                                    color:
                                                        Colors
                                                            .grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const SettingsScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  String _selectedLanguage = 'Français';
  bool _twoFactorEnabled = true;
  int _loginCount = 5;
  String _lastLogin = '2025-11-29 10:30';
  int _connectedDevices = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // En-tête du profil
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Profil'),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Nom: Jean Dupont'),
                            SizedBox(height: 10),
                            Text('Email: jean.dupont@example.com'),
                            SizedBox(height: 10),
                            Text('Numéro d\'étudiant: 202301234'),
                            SizedBox(height: 10),
                            Text('Inscrit depuis: Septembre 2023'),
                            SizedBox(height: 10),
                            Text('Classe: Master 1 Informatique'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fermer'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget.icon,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Jean Dupont',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'jean.dupont@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Section d'informations du profil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations du Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Statut: Étudiant actif'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ProfileInfoTile(
                    icon: Icons.school,
                    label: 'Statut',
                    value: 'Étudiant actif',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Classe: Master 1 Informatique'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ProfileInfoTile(
                    icon: Icons.class_,
                    label: 'Classe',
                    value: 'M1 Informatique',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Téléphone copié: +33 6 12 34 56 78'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ProfileInfoTile(
                    icon: Icons.phone,
                    label: 'Téléphone',
                    value: '+33 6 12 34 56 78',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Section des paramètres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paramètres',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  child: ExpansionTile(
                    leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Notifications'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Activer les notifications'),
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                            if (_notificationsEnabled) ...[
                              SwitchListTile(
                                title: const Text('Notifications par email'),
                                value: _emailNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotifications = value;
                                  });
                                },
                              ),
                              SwitchListTile(
                                title: const Text('Notifications push'),
                                value: _pushNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _pushNotifications = value;
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Langue'),
                    subtitle: Text(_selectedLanguage),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sélectionner la langue'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: ['Français', 'English', 'Español', 'Deutsch'].map((lang) {
                              return ListTile(
                                title: Text(lang),
                                leading: Radio(
                                  value: lang,
                                  groupValue: _selectedLanguage,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLanguage = value!;
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Langue changée en $lang'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Icon(
                      darkModeNotifier.value ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Mode Sombre'),
                    trailing: ValueListenableBuilder<bool>(
                      valueListenable: darkModeNotifier,
                      builder: (context, isDarkMode, child) {
                        return Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            darkModeNotifier.value = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Sécurité'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Paramètres de Sécurité'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Authentification 2FA:'),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _twoFactorEnabled ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _twoFactorEnabled ? 'Activée' : 'Désactivée',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text('Dernière connexion: $_lastLogin'),
                                const SizedBox(height: 10),
                                Text('Total de connexions: $_loginCount'),
                                const SizedBox(height: 10),
                                Text('Appareils connectés: $_connectedDevices'),
                                const SizedBox(height: 15),
                                const Divider(),
                                const SizedBox(height: 15),
                                const Text(
                                  'Appareils actifs:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                _buildDeviceItem('iPhone', 'iOS 17.1', Icons.phone_iphone),
                                const SizedBox(height: 8),
                                _buildDeviceItem('MacBook Pro', 'macOS', Icons.laptop),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Bouton de déconnexion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Déconnexion effectuée'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Déconnexion',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(String name, String os, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                os,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// Écrans de démo pour l'accueil

class MesCoursDemoScreen extends StatefulWidget {
  const MesCoursDemoScreen({super.key});

  @override
  State<MesCoursDemoScreen> createState() => _MesCoursDemoScreenState();
}

class _MesCoursDemoScreenState extends State<MesCoursDemoScreen> {
  final List<Map<String, dynamic>> mesCours = [
    {
      'nom': 'Programmation Dart',
      'professeur': 'Prof. Dupont',
      'heure': 'Lun & Mer 09:00-10:30',
      'salle': 'A101',
      'notes': '18/20',
      'credit': '6 ECTS',
      'progression': 85,
      'etudiants': 32,
      'examens': '2 (écrit 20/20, pratique 16/20)',
    },
    {
      'nom': 'Bases de données',
      'professeur': 'Prof. Martin',
      'heure': 'Mar & Jeu 14:00-15:30',
      'salle': 'B205',
      'notes': '16/20',
      'credit': '6 ECTS',
      'progression': 78,
      'etudiants': 28,
      'examens': '1 (écrit 16/20)',
    },
    {
      'nom': 'Architecture Logicielle',
      'professeur': 'Prof. Bernard',
      'heure': 'Mer 16:00-17:30',
      'salle': 'C310',
      'notes': '17/20',
      'credit': '5 ECTS',
      'progression': 92,
      'etudiants': 25,
      'examens': '1 (projet 17/20)',
    },
    {
      'nom': 'Web Development',
      'professeur': 'Prof. Laurent',
      'heure': 'Ven 10:00-11:30',
      'salle': 'D405',
      'notes': '19/20',
      'credit': '6 ECTS',
      'progression': 88,
      'etudiants': 35,
      'examens': '3 (contrôles + projet)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Mes Cours',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Moyenne générale',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  '17.5/20',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${mesCours.length} cours',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${mesCours.fold<int>(0, (sum, c) => sum + int.parse((c['credit'] as String).split(' ')[0]))} ECTS',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: mesCours.length,
              itemBuilder: (context, index) {
                final cours = mesCours[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(cours['nom'] as String),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Professeur', cours['professeur'] as String),
                                const SizedBox(height: 10),
                                _buildDetailRow('Horaire', cours['heure'] as String),
                                const SizedBox(height: 10),
                                _buildDetailRow('Salle', 'Salle ${cours['salle']}'),
                                const SizedBox(height: 10),
                                _buildDetailRow('Crédits', cours['credit'] as String),
                                const SizedBox(height: 10),
                                _buildDetailRow('Étudiants', '${cours['etudiants']} inscrits'),
                                const SizedBox(height: 15),
                                const Text('Progression du cours', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: (cours['progression'] as int) / 100,
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 5),
                                Text('${cours['progression']}% complété', style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 15),
                                _buildDetailRow('Votre note', cours['notes'] as String),
                                const SizedBox(height: 10),
                                _buildDetailRow('Examens', cours['examens'] as String),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cours['nom'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    cours['notes'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Expanded(child: Text(cours['professeur'] as String)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Expanded(child: Text(cours['heure'] as String)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: (cours['progression'] as int) / 100,
                              minHeight: 6,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Progression: ${cours['progression']}%',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class PlanningDemoScreen extends StatefulWidget {
  const PlanningDemoScreen({super.key});

  @override
  State<PlanningDemoScreen> createState() => _PlanningDemoScreenState();
}

class _PlanningDemoScreenState extends State<PlanningDemoScreen> {
  String _selectedDay = 'Tous';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> planning = [
      {'jour': 'Lundi', 'heure': '09:00-10:30', 'cours': 'Programmation Dart', 'salle': 'A101', 'professeur': 'Prof. Dupont'},
      {'jour': 'Lundi', 'heure': '11:00-12:30', 'cours': 'Bases de données', 'salle': 'B205', 'professeur': 'Prof. Martin'},
      {'jour': 'Mardi', 'heure': '14:00-15:30', 'cours': 'Architecture Logicielle', 'salle': 'C310', 'professeur': 'Prof. Bernard'},
      {'jour': 'Mercredi', 'heure': '09:00-10:30', 'cours': 'Programmation Dart', 'salle': 'A101', 'professeur': 'Prof. Dupont'},
      {'jour': 'Mercredi', 'heure': '16:00-17:30', 'cours': 'Architecture Logicielle', 'salle': 'C310', 'professeur': 'Prof. Bernard'},
      {'jour': 'Jeudi', 'heure': '14:00-15:30', 'cours': 'Bases de données', 'salle': 'B205', 'professeur': 'Prof. Martin'},
      {'jour': 'Vendredi', 'heure': '10:00-11:30', 'cours': 'Web Development', 'salle': 'D405', 'professeur': 'Prof. Laurent'},
    ];

    final filtered = _selectedDay == 'Tous'
        ? planning
        : planning.where((p) => p['jour'] == _selectedDay).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Mon Planning',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtres par jour
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: ['Tous', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi']
                  .map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDay = selected ? day : 'Tous';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Liste des cours filtrés
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 20),
                        const Text('Aucun cours ce jour'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(item['cours'] as String),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow('Jour', item['jour'] as String),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Heure', item['heure'] as String),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Salle', 'Salle ${item['salle']}'),
                                    const SizedBox(height: 10),
                                    _buildDetailRow('Professeur', item['professeur'] as String),
                                    const SizedBox(height: 15),
                                    const Divider(),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Cours ajouté au calendrier'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text('Ajouter au calendrier'),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Fermer'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item['heure']!.split('-')[0],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              title: Text(
                                item['cours']!,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${item['jour']!} - Salle ${item['salle']!}'),
                                  Text(
                                    item['professeur'] as String,
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class MessagesDemoScreen extends StatefulWidget {
  const MessagesDemoScreen({super.key});

  @override
  State<MessagesDemoScreen> createState() => _MessagesDemoScreenState();
}

class _MessagesDemoScreenState extends State<MessagesDemoScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        'auteur': 'Prof. Dupont',
        'sujet': 'Correction du devoir',
        'message': 'Votre devoir a obtenu une note de 18/20. Excellent travail ! Continuez comme ça.',
        'heure': 'Aujourd\'hui 14:30',
        'lu': false,
        'priorite': 'haute',
      },
      {
        'auteur': 'Admin EMIAGE',
        'sujet': 'Réunion importante',
        'message': 'Réunion d\'orientation prévue demain à 10h en amphithéâtre A. Veuillez confirmer votre présence.',
        'heure': 'Hier 16:45',
        'lu': false,
        'priorite': 'haute',
      },
      {
        'auteur': 'Groupe Projet',
        'sujet': 'Code source finalisé',
        'message': 'Le code du projet est maintenant disponible sur le serveur. Vous pouvez le télécharger.',
        'heure': 'Hier 11:20',
        'lu': true,
        'priorite': 'normal',
      },
      {
        'auteur': 'Prof. Martin',
        'sujet': 'Bibliographie du cours',
        'message': 'Voici la liste des livres recommandés pour le cours de bases de données: 1) Database Design, 2) SQL Advanced...',
        'heure': 'Il y a 2 jours',
        'lu': true,
        'priorite': 'normal',
      },
      {
        'auteur': 'Ressources Humaines',
        'sujet': 'Offre de stage chez Google',
        'message': 'Une nouvelle offre de stage intéressante a été publiée pour vous. Durée: 4 mois, Salaire: 1200€/mois.',
        'heure': 'Il y a 3 jours',
        'lu': true,
        'priorite': 'normal',
      },
      {
        'auteur': 'Bibliothèque EMIAGE',
        'sujet': 'Livres disponibles',
        'message': 'Les livres que vous aviez réservés sont maintenant disponibles à la bibliothèque.',
        'heure': 'Il y a 5 jours',
        'lu': true,
        'priorite': 'basse',
      },
    ];

    final nonLusCount = messages.where((m) => !(m['lu'] as bool)).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes Messages',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            if (nonLusCount > 0)
              Text(
                '$nonLusCount nouveau(x) message(s)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  const Text('Aucun message'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isRead = msg['lu'] as bool;
                final priorite = msg['priorite'] as String;
                final prioriteColor = priorite == 'haute'
                    ? Colors.red
                    : priorite == 'normal'
                        ? Colors.blue
                        : Colors.grey;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        messages[index]['lu'] = true;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(msg['sujet'] as String),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'De: ${msg['auteur'] as String}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: prioriteColor.withValues(alpha: 0.1),
                                        border: Border.all(color: prioriteColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        priorite,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: prioriteColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  msg['heure'] as String,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 15),
                                const Divider(),
                                const SizedBox(height: 15),
                                Text(msg['message'] as String),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.reply),
                                  label: const Text('Répondre'),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Fonction de réponse non disponible'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
              elevation: isRead ? 1 : 3,
              color: isRead ? Colors.white : Colors.blue.withValues(alpha: 0.05),
              child: ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        (msg['auteur'] as String)[0],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  msg['sujet'] as String,
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg['message']!.length > 60
                          ? '${(msg['message'] as String).substring(0, 60)}...'
                          : msg['message'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isRead ? Colors.grey : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      msg['auteur'] as String,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      msg['heure'] as String,
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      priorite == 'haute' ? Icons.priority_high : Icons.inbox,
                      color: prioriteColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
                  ),
                );
              },
            ),
    );
  }
}

// Écran Plats - Restaurant Edmon

class PlatsScreen extends StatefulWidget {
  const PlatsScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  State<PlatsScreen> createState() => _PlatsScreenState();
}

class _PlatsScreenState extends State<PlatsScreen> {
  final Map<int, int> _panier = {}; // Index du plat -> quantité

  final List<Map<String, dynamic>> plats = [
    {
      'nom': 'Yassa de Poulet',
      'description': 'Poulet mariné aux oignons, citron et piment',
      'prix': 1500,
      'icon': Icons.lunch_dining,
      'couleur': Colors.orange,
    },
    {
      'nom': 'Attiéké Porc Grillé',
      'description': 'Pâte de manioc avec porc grillé à la perfection',
      'prix': 1000,
      'icon': Icons.fastfood,
      'couleur': Colors.red,
    },
    {
      'nom': 'Alloco Œuf',
      'description': 'Bananes plantains frites avec œuf cuit',
      'prix': 700,
      'icon': Icons.restaurant_menu,
      'couleur': Colors.amber,
    },
    {
      'nom': 'Alloco Poulet',
      'description': 'Bananes plantains frites avec poulet tendre',
      'prix': 1000,
      'icon': Icons.restaurant_menu,
      'couleur': Colors.deepOrange,
    },
    {
      'nom': 'Poisson Braisé',
      'description': 'Poisson frais grillé aux épices',
      'prix': 2000,
      'icon': Icons.set_meal,
      'couleur': Colors.blue,
    },
  ];

  int get _totalItems => _panier.values.fold(0, (sum, qty) => sum + qty);
  int get _totalPrix => _panier.entries.fold(0, (sum, entry) {
    final index = entry.key;
    final qty = entry.value;
    return sum + (plats[index]['prix'] as int) * qty;
  });

  void _ajouterAuPanier(int index) {
    setState(() {
      _panier[index] = (_panier[index] ?? 0) + 1;
    });
  }

  void _retirerDuPanier(int index) {
    setState(() {
      if (_panier[index] != null && _panier[index]! > 0) {
        _panier[index] = _panier[index]! - 1;
        if (_panier[index] == 0) {
          _panier.remove(index);
        }
      }
    });
  }

  String _buildWhatsAppMessage() {
    StringBuffer message = StringBuffer();
    message.writeln("Salut Edmon je t'appelle pour commander");
    message.writeln("");
    
    for (var entry in _panier.entries) {
      final index = entry.key;
      final qty = entry.value;
      final plat = plats[index];
      final sousTotal = (plat['prix'] as int) * qty;
      message.writeln("🍽️ ${plat['nom']} x$qty - $sousTotal FCFA");
    }
    
    message.writeln("");
    message.writeln("💰 TOTAL: $_totalPrix FCFA");
    message.writeln("");
    message.writeln("Merci!");
    
    return message.toString();
  }

  Future<void> _envoyerViaWhatsApp() async {
    final message = _buildWhatsAppMessage();
    final whatsappUrl = "https://wa.me/2250564719487?text=${Uri.encodeComponent(message)}";
    
    try {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _passerCommande() {
    if (_panier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter des plats à votre commande'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Récapitulatif de Commande'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restaurant Edmon',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              ..._panier.entries.map((entry) {
                final index = entry.key;
                final qty = entry.value;
                final plat = plats[index];
                final sousTotal = (plat['prix'] as int) * qty;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plat['nom'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'x$qty',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$sousTotal FCFA',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_totalPrix FCFA',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _envoyerViaWhatsApp();
              setState(() {
                _panier.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Confirmer Commande',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Restaurant Edmon',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // En-tête restaurant
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant Edmon',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          'Cuisine Africaine Authentique',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  '🔥 Découvrez nos meilleures spécialités! 🔥',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Liste des plats
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: plats.length,
              itemBuilder: (context, index) {
                final plat = plats[index];
                final quantite = _panier[index] ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (plat['couleur'] as Color).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: (plat['couleur'] as Color).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    plat['icon'] as IconData,
                                    color: plat['couleur'] as Color,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plat['nom'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        plat['description'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${plat['prix']} FCFA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: plat['couleur'] as Color,
                                  ),
                                ),
                                if (quantite == 0)
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    label: const Text('Ajouter'),
                                    onPressed: () => _ajouterAuPanier(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: plat['couleur'] as Color,
                                    ),
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => _retirerDuPanier(index),
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$quantite',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => _ajouterAuPanier(index),
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Barre de commande
          if (_panier.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_totalItems article(s)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        '$_totalPrix FCFA',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Passer Commande'),
                    onPressed: _passerCommande,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}