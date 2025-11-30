import 'package:flutter/material.dart';
import '../main.dart';

class TabScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const TabScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour 🌅';
    } else if (hour < 18) {
      return 'Bon après-midi ☀️';
    } else {
      return 'Bonsoir 🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final announcements = [
      {
        'title': 'Réunion de rentrée',
        'description': "Une réunion d'information est prévue pour présenter les objectifs du semestre.",
        'type': 'Annonce',
        'color': Colors.red,
      },
      {
        'title': 'Semaine d\'intégration',
        'description': "Rejoignez-nous pour une semaine d'activités et d'ateliers.",
        'type': 'Événement',
        'color': Colors.green,
      },
      {
        'title': 'Nouveau cours disponible',
        'description': 'Le cours de Développement Mobile avancé est maintenant disponible.',
        'type': 'Information',
        'color': Colors.blue,
      },
    ];
    
    return Container(
      color: isDark ? const Color(0xFF0F1419) : const Color(0xFFF8F9FC),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec gradient moderne
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF9D84FF),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<String?>(
                              valueListenable: userFirstNameNotifier,
                              builder: (context, firstName, _) {
                                return ValueListenableBuilder<String?>(
                                  valueListenable: userLastNameNotifier,
                                  builder: (context, lastName, _) {
                                    final greeting = _getGreeting();
                                    final displayName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
                                    return Text(
                                      displayName.isEmpty
                                          ? greeting
                                          : '$greeting ${displayName.split(' ')[0]}!',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<String?>(
                              valueListenable: userLevelNotifier,
                              builder: (context, level, _) {
                                return Text(
                                  level != null ? '📚 Niveau: $level' : '🎓 Bienvenue !',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Contenu principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Statistiques moderne
                  Text(
                    'Aperçu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grille de statistiques avec design moderne
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernStatCard(
                          context,
                          'Cours actifs',
                          '0',
                          Icons.book_rounded,
                          const Color(0xFF6C63FF),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModernStatCard(
                          context,
                          'Événements',
                          '0',
                          Icons.event_rounded,
                          const Color(0xFF25D366),
                          isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernStatCard(
                          context,
                          'Annonces',
                          announcements.length.toString(),
                          Icons.notifications_rounded,
                          const Color(0xFFFF6B6B),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModernStatCard(
                          context,
                          'Grades',
                          '--',
                          Icons.grade_rounded,
                          const Color(0xFFFFA500),
                          isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Emploi du temps
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Emploi du temps',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aller au planning complet')),
                        ),
                        child: Text(
                          'Voir tout',
                          style: TextStyle(
                            color: const Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Emploi du temps vide
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark 
                          ? Colors.grey[700]! 
                          : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF6C63FF),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aucun cours prévu',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Détendez-vous, pas de cours aujourd\'hui',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Publications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dernières actualités',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Voir toutes les publications')),
                        ),
                        child: Text(
                          'Voir tout',
                          style: TextStyle(
                            color: const Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Cartes de publications modernisées
                  ...List.generate(announcements.length, (i) {
                    final a = announcements[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildModernAnnouncementCard(context, a, isDark),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildModernStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildModernAnnouncementCard(BuildContext context, Map<String, dynamic> announcement, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: announcement['color'].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: announcement['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        announcement['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: announcement['color'].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        announcement['type'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: announcement['color'],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  announcement['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            size: 20,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
