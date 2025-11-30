import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_design.dart';
import '../main.dart';
import 'publication_detail_screen.dart';
import 'dart:io';

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
  String _currentTab = 'publications';
  final List<String> _filterOptions = ['Tous', 'Annonce', 'Événement', 'Information', 'Offre d\'emploi'];
  final Set<int> _favorites = {0, 2};
  late List<Map<String, String>> _ressourcesLocal;

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

  @override
  void initState() {
    super.initState();
    _ressourcesLocal = ressources;
  }

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppDesign.mainGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppDesign.radiusXL),
              bottomRight: Radius.circular(AppDesign.radiusXL),
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTab = 'ressources';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _currentTab == 'ressources'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Ressources (${_ressourcesLocal.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _currentTab == 'ressources'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _currentTab == 'ressources'
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
        if (_currentTab == 'ressources')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton.icon(
              onPressed: _ajouterRessource,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter Image/Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        if (_currentTab == 'publications') const SizedBox(height: 15),
        if (_currentTab == 'ressources') const SizedBox(height: 15),
        Expanded(
          child: _currentTab == 'ressources'
              ? _ressourcesLocal.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 80,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[600]
                                : Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          const Text('Aucune ressource pour le moment'),
                          const SizedBox(height: 6),
                          const Text('Ajoutez des images ou documents'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: _ressourcesLocal.length,
                      itemBuilder: (context, index) {
                        final ressource = _ressourcesLocal[index];
                        final isImage = ressource['type'] == 'image';
                        final nomFichier = ressource['nom'] ?? 'Fichier';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (isImage) {
                                _afficherImage(ressource['chemin'] ?? '');
                              } else {
                                _afficherDocument(ressource['chemin'] ?? '', nomFichier);
                              }
                            },
                            child: Card(
                              elevation: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: isImage
                                            ? Colors.blue.withValues(alpha: 0.1)
                                            : Colors.orange.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: isImage
                                          ? Image.file(
                                              File(ressource['chemin'] ?? ''),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image),
                                            )
                                          : Icon(
                                              Icons.description,
                                              color: Colors.orange,
                                              size: 32,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nomFichier,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                ressource['type'] == 'image' ? '📷 Image' : '📄 Document',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                ressource['taille'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ressource['date'] ?? '',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
              : displayedPubs.isEmpty
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
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          _showPublicationDetails(context, pub);
                        },
                        child: Card(
                          elevation: 0,
                          color: isDark ? Colors.grey[850] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDesign.radiusL),
                            side: BorderSide(
                              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getTypeIcon(pub['type'] ?? ''),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pub['titre'] ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            pub['contenu'] != null && pub['contenu']!.length > 60
                                                ? '${pub['contenu']!.substring(0, 60)}...'
                                                : pub['contenu'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _favorites.contains(pubIndex)
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: _favorites.contains(pubIndex)
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _toggleFavorite(pubIndex);
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Par ${pub['auteur'] ?? 'Auteur'}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getTypeColor(pub['type'] ?? '').withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        pub['type'] ?? '',
                                        style: TextStyle(
                                          color: _getTypeColor(pub['type'] ?? ''),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
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
      ],
    );
  }

  Widget _getTypeIcon(String type) {
    switch (type) {
      case 'Annonce':
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
          ),
          child: const Icon(Icons.campaign_rounded, color: Colors.blue, size: 22),
        );
      case 'Événement':
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
          ),
          child: const Icon(Icons.event_rounded, color: Colors.green, size: 22),
        );
      case 'Information':
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
          ),
          child: const Icon(Icons.info_rounded, color: Colors.orange, size: 22),
        );
      case 'Offre d\'emploi':
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
          ),
          child: const Icon(Icons.work_rounded, color: Colors.purple, size: 22),
        );
      default:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
          ),
          child: const Icon(Icons.info_rounded, color: Colors.grey, size: 22),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PublicationDetailScreen(publication: pub),
      ),
    );
  }

  Future<void> _ajouterRessource() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx', 'xls', 'jpg', 'jpeg', 'png', 'gif', 'bmp'],
        withData: true,
      );

      if (result == null) return;

      final file = result.files.single;
      final fileName = file.name;
      final filePath = file.path ?? '';
      final fileSize = file.size;

      final extension = fileName.split('.').last.toLowerCase();
      final isImage = ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension);
      final isDocument = ['pdf', 'doc', 'docx', 'xlsx', 'xls'].contains(extension);

      if (!isImage && !isDocument) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Type de fichier non supporté')),
        );
        return;
      }

      setState(() {
        ressources.add({
          'nom': fileName,
          'chemin': filePath,
          'type': isImage ? 'image' : 'document',
          'extension': extension,
          'taille': '${(fileSize / 1024).toStringAsFixed(2)} KB',
          'date': DateTime.now().toString().split(' ')[0],
          'auteur': userFirstNameNotifier.value ?? 'Utilisateur',
        });
        _ressourcesLocal = ressources;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ressource ajoutée avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _afficherImage(String cheminImage) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Image.file(
                  File(cheminImage),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _afficherDocument(String cheminDocument, String nomFichier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nomFichier),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nomFichier,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Chemin: $cheminDocument',
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Le fichier est prêt à être ouvert. Cliquez sur "Ouvrir" pour le visualiser avec votre application par défaut.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ouvrir'),
            onPressed: () {
              _openFile(cheminDocument);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chemin: $filePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
}
