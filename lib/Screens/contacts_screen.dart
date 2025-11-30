import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_design.dart';

class ContactsScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const ContactsScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Map<String, String>> contacts = [
    {
      'nom': 'Joël Attitso',
      'description': 'Meilleur codeur de MIAGE',
      'numero': '+22555745936',
    },
    {
      'nom': 'Emeric Soro',
      'description': 'Meilleur codeur de MIAGE',
      'numero': '+22587617392',
    },
    {
      'nom': 'Mr Kouakou Florent',
      'description': 'Professeur de Statistiques',
      'numero': '+22507123456',
    },
    {
      'nom': 'Mr Ngolo Konaté',
      'description': 'Professeur d\'Outils formels et POO Java',
      'numero': '+22508234567',
    },
    {
      'nom': 'Mr Harouna Coulibaly',
      'description': 'Professeur de Probabilité 2',
      'numero': '+22509345678',
    },
    {
      'nom': 'Mr N\'Drin Apala',
      'description': 'Professeur d\'Analyses de données',
      'numero': '+22510456789',
    },
    {
      'nom': 'Mr Sonzai Théodore',
      'description': 'Professeur de Modèle comptable et opération comptable',
      'numero': '+22511567890',
    },
    {
      'nom': 'Mr Yolli',
      'description': 'Professeur d\'Économie',
      'numero': '+22512678901',
    },
  ];

  Future<void> _contactViaWhatsApp(String numero, String nom, String description) async {
    final message = 'Contacter $nom - $description';
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/$numero?text=$encodedMessage';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('WhatsApp n\'est pas installé'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                  child: InkWell(
                    onTap: () {
                      _contactViaWhatsApp(
                        contact['numero']!,
                        contact['nom']!,
                        contact['description']!,
                      );
                    },
                    borderRadius: BorderRadius.circular(AppDesign.radiusL),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppDesign.mainGradient,
                              borderRadius: BorderRadius.circular(AppDesign.radiusM),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact['nom']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contact['description']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(AppDesign.radiusM),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.chat_rounded),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () {
                                _contactViaWhatsApp(
                                  contact['numero']!,
                                  contact['nom']!,
                                  contact['description']!,
                                );
                              },
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
}

