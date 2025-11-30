import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_design.dart';

class PlatsScreen extends StatefulWidget {
  const PlatsScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  State<PlatsScreen> createState() => _PlatsScreenState();
}

class _PlatsScreenState extends State<PlatsScreen> {
  final Map<int, int> _panier = {};

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
          SnackBar(content: Text('Erreur: $e'), duration: const Duration(seconds: 3)),
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Récapitulatif de Commande'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Restaurant Edmon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                            Text(plat['nom'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('x$qty', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Text('$sousTotal FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('$_totalPrix FCFA', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _envoyerViaWhatsApp();
              setState(() { _panier.clear(); });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirmer Commande', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatCard(BuildContext context, int index) {
    final plat = plats[index];
    final quantite = _panier[index] ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                      color: (plat['couleur'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesign.radiusM),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          plat['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                      fontWeight: FontWeight.w700,
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
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(AppDesign.radiusS),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _retirerDuPanier(index),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              '$quantite',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _ajouterAuPanier(index),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Restaurant Edmon',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Cuisine Africaine Authentique',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
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
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: List.generate(plats.length, (index) => _buildPlatCard(context, index)),
          ),
        ),
        if (_panier.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_totalItems article(s)', style: TextStyle(color: Colors.grey[600])),
                    Text('$_totalPrix FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Passer Commande'),
                  onPressed: _passerCommande,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
