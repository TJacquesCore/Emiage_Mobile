import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_design.dart';

class CoursScreen extends StatefulWidget {
  const CoursScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  State<CoursScreen> createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  final List<Map<String, String>> quickLevels = const [
    {'label': 'L1', 'url': 'https://drive.google.com/drive/folders/1x4dg2FcYnLQ1lVUpgSsU0m4VLq_O4kb6?usp=sharing'},
    {'label': 'L2', 'url': 'https://drive.google.com/drive/folders/1a-tfoI9Z6Qvkm7WOeDqHlXYMuxCoi2gU?usp=sharing'},
    {'label': 'L3', 'url': 'https://emiage-gi.onrender.com/bibliotheque/l3'},
    {'label': 'M1', 'url': 'https://emiage-gi.onrender.com/bibliotheque/m1'},
    {'label': 'M2', 'url': 'https://emiage-gi.onrender.com/bibliotheque/m2'},
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir l\'URL')),
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
                Icons.school_rounded,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                'Cours',
                style: TextStyle(
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
            itemCount: quickLevels.length,
            itemBuilder: (context, index) {
              final data = quickLevels[index];
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
                    onTap: () => _openUrl(data['url']!),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                data['label']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Niveau ${data['label']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Accédez aux cours',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppDesign.primaryGradient1,
                            size: 20,
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
