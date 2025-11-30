import 'package:flutter/material.dart';

class MessagesDemoScreen extends StatefulWidget {
  const MessagesDemoScreen({super.key});

  @override
  State<MessagesDemoScreen> createState() => _MessagesDemoScreenState();
}

class _MessagesDemoScreenState extends State<MessagesDemoScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {'auteur': 'Prof. Dupont', 'sujet': 'Correction du devoir', 'msg': 'Votre devoir a obtenu 18/20 !', 'heure': 'Aujourd\'hui 14:30', 'lu': false, 'priorite': 'haute'},
      {'auteur': 'Admin EMIAGE', 'sujet': 'Réunion importante', 'msg': 'Réunion demain à 10h en amphithéâtre A', 'heure': 'Hier 16:45', 'lu': false, 'priorite': 'haute'},
      {'auteur': 'Groupe Projet', 'sujet': 'Code source finalisé', 'msg': 'Le code du projet est disponible', 'heure': 'Hier 11:20', 'lu': true, 'priorite': 'normal'},
      {'auteur': 'Prof. Martin', 'sujet': 'Bibliographie du cours', 'msg': 'Liste des livres recommandés...', 'heure': 'Il y a 2 jours', 'lu': true, 'priorite': 'normal'},
      {'auteur': 'Ressources Humaines', 'sujet': 'Offre de stage Google', 'msg': 'Nouvelle offre : 4 mois, 1200€/mois', 'heure': 'Il y a 3 jours', 'lu': true, 'priorite': 'normal'},
      {'auteur': 'Bibliothèque', 'sujet': 'Livres disponibles', 'msg': 'Vos livres réservés sont disponibles', 'heure': 'Il y a 5 jours', 'lu': true, 'priorite': 'basse'},
    ];
    
    final nonLusCount = messages.where((m) => !(m['lu'] as bool)).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes Messages', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            if (nonLusCount > 0) Text('$nonLusCount nouveau(x)', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isRead = msg['lu'] as bool;
          final priorite = msg['priorite'] as String;
          final prioriteColor = priorite == 'haute' ? Colors.red : priorite == 'normal' ? Colors.blue : Colors.grey;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                setState(() { messages[index]['lu'] = true; });
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(msg['sujet']),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('De: ${msg['auteur']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: prioriteColor.withOpacity(0.1), border: Border.all(color: prioriteColor), borderRadius: BorderRadius.circular(8)), child: Text(priorite, style: TextStyle(fontSize: 11, color: prioriteColor, fontWeight: FontWeight.bold)))
                          ]),
                          const SizedBox(height: 5),
                          Text(msg['heure'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(height: 15),
                          const Divider(),
                          const SizedBox(height: 15),
                          Text(msg['msg']),
                        ],
                      ),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Fermer'))],
                  ),
                );
              },
              child: Card(
                elevation: isRead ? 1 : 3,
                color: isRead ? Colors.white : Colors.blue.withOpacity(0.05),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text((msg['auteur'] as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      if (!isRead)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(7), border: Border.all(color: Colors.white, width: 1.5)),
                          ),
                        ),
                    ],
                  ),
                  title: Text(msg['sujet'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((msg['msg'] as String).length > 50 ? '${(msg['msg'] as String).substring(0, 50)}...' : msg['msg'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isRead ? Colors.grey : Colors.black87)),
                      const SizedBox(height: 3),
                      Text(msg['auteur'], style: TextStyle(fontSize: 11, color: Colors.grey[500])),
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
